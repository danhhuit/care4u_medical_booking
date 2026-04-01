import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthCenterPage extends StatefulWidget {
  const HealthCenterPage({super.key});

  @override
  State<HealthCenterPage> createState() => _HealthCenterPageState();
}

class _HealthCenterPageState extends State<HealthCenterPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(10.762622, 106.660172); // Trung tâm y tế mẫu giả lập ở TPHCM

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể thiết lập cuộc gọi trên thiết bị này')),
        );
      }
    }
  }

  Future<void> _openMapUrl() async {
    // Khởi chạy map app ngoại bộ (Google map/Apple map app) nếu muốn xem lớn hơn
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${_center.latitude},${_center.longitude}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể mở bản đồ ngoài')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Trung tâm Y tế Care4U', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Giao diện Bản đồ Google Map có thể vuốt và tương tác
            SizedBox(
              height: 250,
              width: double.infinity,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 16.0,
                ),
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                scrollGesturesEnabled: true,
                markers: {
                  Marker(
                    markerId: const MarkerId('care4u_center'),
                    position: _center,
                    infoWindow: const InfoWindow(
                      title: 'Trung tâm Y tế Care4U',
                      snippet: '83/1 Đ. Vườn Lài, Phú Thọ Hòa, Tân Phú, TP.HCM',
                    ),
                  )
                },
              ),
            ),
            
            // Các nút Thông tin có thể ấn qua InkWell/Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thông tin chung', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  // Card Địa chỉ
                  _buildCardItem(
                    icon: Icons.location_on,
                    title: 'Địa chỉ',
                    subtitle: '83/1 Đ. Vườn Lài, Phú Thọ Hòa, Tân Phú, Hồ Chí Minh, Việt Nam',
                    onTap: _openMapUrl, // Bấm vào để mở Google Map app
                  ),
                  
                  // Card Liên hệ
                  _buildCardItem(
                    icon: Icons.phone_in_talk,
                    title: 'Thông tin liên hệ',
                    subtitle: 'Đường dây nóng: 1900 1234\nEmail: contact@care4u.vn',
                    onTap: () => _makePhoneCall('19001234'), // Bấm vào để mở màn hình gọi
                  ),
                  
                  // Card Giờ làm việc
                  _buildCardItem(
                    icon: Icons.access_time_filled,
                    title: 'Giờ làm việc',
                    subtitle: 'Thứ 2 - Thứ 6: 07:30 - 16:30\nThứ 7: 07:30 - 11:30\nChủ nhật : Nghỉ',
                    onTap: () {
                      _showWorkingHoursDialog(context); // Bấm vào để mở khung chi tiết
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tiện ích vẽ ô Card có hiệu ứng ấn
  Widget _buildCardItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Tiện ích hiển thị bảng Giờ Mở Cửa từ dưới lên (Bottom Sheet)
  void _showWorkingHoursDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chi tiết giờ làm việc', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildDayRow('Thứ 2 - Thứ 6', '07:30 - 16:30'),
              const Divider(),
              _buildDayRow('Thứ 7', '07:30 - 11:30'),
              const Divider(),
              _buildDayRow('Chủ nhật', 'Nghỉ'),
              const Divider(),
              _buildDayRow('Ngày Lễ, Tết', 'Trực cấp cứu'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Đóng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          Text(time, style: TextStyle(
            color: time.contains('Nghỉ') ? Colors.red : Colors.black87, 
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
    );
  }
}
