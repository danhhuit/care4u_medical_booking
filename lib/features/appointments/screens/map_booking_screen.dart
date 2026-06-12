import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class MapBookingScreen extends StatefulWidget {
  const MapBookingScreen({super.key});

  @override
  State<MapBookingScreen> createState() => _MapBookingScreenState();
}

class _MapBookingScreenState extends State<MapBookingScreen> {
  GoogleMapController? mapController;

  final LatLng _defaultCenter = const LatLng(10.7769, 106.7009); // HCM City Center
  LatLng? _currentPosition;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = false;
  
  String? _routeDistance;
  String? _routeDuration;

  // Thay thế bằng API Key thật từ SerpAPI nếu có
  final String _serpApiKey = "21de763ac850be529a402f7da674340632e2901efc4091e31a8762144e715d80";
  final String _googleApiKey = "AIzaSyAtsMpnM2eSu3DBAnaM8JuBpAI6CcIcUXg";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    void fallbackToDefault(String reason) {
      if (mounted) {
        setState(() {
          _currentPosition = _defaultCenter;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dùng vị trí mặc định do: $reason')));
        _fetchClinicsFromSerpApi(_defaultCenter, "Phòng khám bệnh viện");
      }
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      fallbackToDefault('Chưa bật GPS (Location Service) trên máy');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        fallbackToDefault('Bị từ chối quyền truy cập vị trí');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      fallbackToDefault('Quyền vị trí bị chặn vĩnh viễn trong Cài đặt');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 10));
      if (mounted) {
        setState(() {
          // Kiểm tra nếu vị trí nằm ngoài lãnh thổ Việt Nam (Ví dụ Emulator mặc định ở Mỹ)
          if (position.latitude < 8.0 || position.latitude > 23.5 || position.longitude < 102.0 || position.longitude > 110.0) {
            _currentPosition = _defaultCenter; // Ép về HCM
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vị trí giả lập không ở VN, đã ép về trung tâm TP.HCM')));
          } else {
            _currentPosition = LatLng(position.latitude, position.longitude);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật vị trí GPS thành công!')));
          }
        });
        
        if (mapController != null) {
          mapController!.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 14.0));
        }
        
        _fetchClinicsFromSerpApi(_currentPosition!, "Phòng khám bệnh viện");
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
      if (mounted) {
        setState(() {
          _currentPosition = _defaultCenter;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể tải GPS (Timeout hoặc lỗi phần cứng), dùng vị trí mặc định')));
        _fetchClinicsFromSerpApi(_defaultCenter, "Phòng khám bệnh viện");
      }
    }
  }

  Future<void> _drawRoute(LatLng destination) async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chưa xác định được vị trí của bạn')));
      return;
    }
    
    setState(() {
      _isLoading = true;
      _polylines.clear();
      _routeDistance = null;
      _routeDuration = null;
    });
    
    // Sử dụng OSRM (Open Source Routing Machine) - API miễn phí, không cần Key
    // Chú ý: OSRM yêu cầu định dạng kinh độ, vĩ độ (longitude, latitude)
    final origin = '${_currentPosition!.longitude},${_currentPosition!.latitude}';
    final dest = '${destination.longitude},${destination.latitude}';
    final url = 'http://router.project-osrm.org/route/v1/driving/$origin;$dest?overview=full&geometries=polyline';
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          
          final distanceMeters = route['distance'] ?? 0;
          final durationSecondsRaw = route['duration'] ?? 0;
          
          // format distance
          String distText = distanceMeters > 1000 
              ? '${(distanceMeters / 1000).toStringAsFixed(1)} km'
              : '${distanceMeters.toStringAsFixed(0)} m';
              
          // format duration
          int durationSeconds = durationSecondsRaw.toInt();
          int durationMinutes = durationSeconds ~/ 60;
          String durText = durationMinutes > 60 
              ? '${durationMinutes ~/ 60} giờ ${durationMinutes % 60} phút'
              : '$durationMinutes phút';
          
          final points = route['geometry'];
          final polylineCoordinates = _decodePolyline(points);
          
          setState(() {
            _routeDistance = distText;
            _routeDuration = durText;
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: Colors.blue,
                width: 5,
                points: polylineCoordinates,
              ),
            );
          });
          
          // Zoom to fit polyline
          if (mapController != null) {
             mapController!.animateCamera(CameraUpdate.newLatLngBounds(
               _boundsFromLatLngList(polylineCoordinates), 50
             ));
          }
        } else {
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OSRM không tìm thấy tuyến đường, đang mở Google Maps...')));
             _launchGoogleMaps(destination);
          }
        }
      } else {
        if (mounted) {
           debugPrint("Lỗi OSRM API: ${response.statusCode}");
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Máy chủ vẽ đường đang bận, đang chuyển sang Google Maps...')));
           _launchGoogleMaps(destination);
        }
      }
    } catch (e) {
      debugPrint('Lỗi vẽ đường: $e');
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang mở Google Maps do lỗi hệ thống...')));
         _launchGoogleMaps(destination);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _launchGoogleMaps(LatLng destination) async {
    final uri = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể mở ứng dụng Google Maps')));
      }
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }
    return polyline;
  }

  Future<void> _fetchClinicsFromSerpApi(LatLng location, String query) async {
    setState(() {
      _isLoading = true;
    });

    // ll: vĩ độ, kinh độ, mức zoom
    final ll = "@${location.latitude},${location.longitude},14z";
    
    final url = Uri.parse(
        'https://serpapi.com/search.json?engine=google_maps&q=$query&ll=$ll&hl=vi&api_key=$_serpApiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final localResults = data['local_results'] as List<dynamic>?;

        if (localResults != null) {
          Set<Marker> newMarkers = {};
          
          for (var result in localResults) {
            final coords = result['gps_coordinates'];
            if (coords != null) {
              final lat = coords['latitude'];
              final lng = coords['longitude'];
              final title = result['title'] ?? 'Phòng khám';
              final address = result['address'] ?? 'Đang cập nhật địa chỉ...';

              newMarkers.add(
                Marker(
                  markerId: MarkerId(result['place_id'] ?? title),
                  position: LatLng(lat, lng),
                  infoWindow: InfoWindow(
                    title: title,
                    snippet: 'Bấm để xem chi tiết',
                  ),
                  onTap: () {
                     _showClinicInfoBottomSheet(title, address, lat, lng);
                  },
                ),
              );
            }
          }

          if (mounted) {
            setState(() {
              _markers = newMarkers;
            });
          }
        }
      } else {
        debugPrint("Lỗi SerpAPI: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Lỗi kết nối SerpAPI: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 14.0));
    }
  }

  void _showClinicInfoBottomSheet(String name, String address, double lat, double lng) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                         Navigator.pop(context); // Close bottom sheet
                         _drawRoute(LatLng(lat, lng));
                      },
                      icon: const Icon(Icons.directions, color: Colors.blue),
                      label: const Text('Tìm đường', style: TextStyle(color: Colors.blue)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.blue),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, RouteNames.doctorList);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Đặt Lịch', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.tr('book_now') ?? 'Tìm phòng khám'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? _defaultCenter,
              zoom: 14.0,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // Tắt nút mặc định để dùng nút custom
          ),
          
          Positioned(
            bottom: (_routeDistance != null) ? 140 : 30, // Nhích lên nếu có bảng route
            right: 16,
            child: FloatingActionButton(
              heroTag: 'my_location',
              backgroundColor: Colors.white,
              onPressed: () {
                _getCurrentLocation();
              },
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
          
          if (_routeDistance != null && _routeDuration != null)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.directions_car, color: Colors.blue, size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_routeDuration!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                          Text('Quãng đường: $_routeDistance', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _polylines.clear();
                          _routeDistance = null;
                          _routeDuration = null;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
                ],
              ),
              child: TextField(
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                     _fetchClinicsFromSerpApi(_currentPosition ?? _defaultCenter, value);
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm phòng khám, bệnh viện...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
        ],
      ),
    );
  }
}
