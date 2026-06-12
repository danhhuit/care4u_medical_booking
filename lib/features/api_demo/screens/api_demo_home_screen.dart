import 'package:flutter/material.dart';
import '../../../core/api/care4u_api_service.dart';
import '../../doctors/screens/api_doctors_screen.dart';

class ApiDemoHomeScreen extends StatefulWidget {
  const ApiDemoHomeScreen({super.key});

  @override
  State<ApiDemoHomeScreen> createState() => _ApiDemoHomeScreenState();
}

class _ApiDemoHomeScreenState extends State<ApiDemoHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ApiDoctorsScreen(),
    ApiSpecialtiesTab(),
    ApiStoreProductsTab(),
    ApiAppointmentsTab(),
  ];

  final List<String> _titles = const [
    'Bác sĩ',
    'Chuyên khoa',
    'Sản phẩm',
    'Lịch hẹn',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Care4U - ${_titles[_currentIndex]}')),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.medical_services),
            label: 'Bác sĩ',
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: 'Chuyên khoa',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag),
            label: 'Sản phẩm',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Lịch hẹn',
          ),
        ],
      ),
    );
  }
}

class ApiSpecialtiesTab extends StatefulWidget {
  const ApiSpecialtiesTab({super.key});

  @override
  State<ApiSpecialtiesTab> createState() => _ApiSpecialtiesTabState();
}

class _ApiSpecialtiesTabState extends State<ApiSpecialtiesTab> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadSpecialties();
  }

  Future<void> _loadSpecialties() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _api.getSpecialties();
      if (!mounted) return;

      setState(() {
        _items = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Không thể tải chuyên khoa: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }

    return RefreshIndicator(
      onRefresh: _loadSpecialties,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(child: Text('${item['id'] ?? ''}')),
              title: Text(item['name'] ?? 'Chưa có tên'),
              subtitle: Text(item['description'] ?? 'Không có mô tả'),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}

class ApiStoreProductsTab extends StatefulWidget {
  const ApiStoreProductsTab({super.key});

  @override
  State<ApiStoreProductsTab> createState() => _ApiStoreProductsTabState();
}

class _ApiStoreProductsTabState extends State<ApiStoreProductsTab> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _api.getStoreProducts();
      if (!mounted) return;

      setState(() {
        _items = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Không thể tải sản phẩm: $e';
        _isLoading = false;
      });
    }
  }

  String _formatPrice(dynamic value) {
    final number = double.tryParse('${value ?? 0}');
    if (number == null) return '${value ?? 0} đ';
    return '${number.toStringAsFixed(0)} đ';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.medication)),
              title: Text(item['name'] ?? 'Chưa có tên'),
              subtitle: Text(
                'Giá: ${_formatPrice(item['price'])}\nTồn kho: ${item['stockQuantity'] ?? 0}',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}

class ApiAppointmentsTab extends StatefulWidget {
  const ApiAppointmentsTab({super.key});

  @override
  State<ApiAppointmentsTab> createState() => _ApiAppointmentsTabState();
}

class _ApiAppointmentsTabState extends State<ApiAppointmentsTab> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _api.getAppointments();
      if (!mounted) return;

      setState(() {
        _items = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Không thể tải lịch hẹn: $e';
        _isLoading = false;
      });
    }
  }

  Color _statusColor(dynamic status) {
    final value = '${status ?? ''}'.toLowerCase();

    if (value.contains('completed')) return Colors.green;
    if (value.contains('cancel')) return Colors.red;
    if (value.contains('confirmed')) return Colors.blue;
    return Colors.orange;
  }

  String _statusText(dynamic status) {
    final value = '${status ?? ''}'.toLowerCase();

    if (value.contains('pending')) return 'Đang chờ xác nhận';
    if (value.contains('confirmed')) return 'Đã xác nhận';
    if (value.contains('completed')) return 'Đã hoàn thành';
    if (value.contains('cancel')) return 'Đã hủy';

    return '${status ?? 'Không rõ'}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }

    if (_items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadAppointments,
        child: ListView(
          children: const [
            SizedBox(height: 200),
            Center(child: Text('Chưa có lịch hẹn nào')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];

          final appointmentNo = item['appointmentNo'] ?? 'Lịch hẹn';
          final patientName = item['patientName'] ?? 'Bệnh nhân ID: ${item['patientId']}';
          final doctorName = item['doctorName'] ?? 'Bác sĩ ID: ${item['doctorId']}';
          final doctorTitle = item['doctorTitle'] ?? '';
          final specialtyName = item['specialtyName'] ?? 'Chưa có chuyên khoa';
          final healthCenterName = item['healthCenterName'] ?? 'Chưa có cơ sở khám';
          final reason = item['reason'] ?? 'Không có lý do';
          final createdAt = item['createdAt'] ?? '';
          final status = item['status'];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _statusColor(status),
                        child: const Icon(Icons.calendar_month, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          appointmentNo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Chip(
                        label: Text(
                          _statusText(status),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _statusColor(status),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text('Bệnh nhân: $patientName'),
                  const SizedBox(height: 6),
                  Text('Bác sĩ: $doctorTitle $doctorName'),
                  const SizedBox(height: 6),
                  Text('Chuyên khoa: $specialtyName'),
                  const SizedBox(height: 6),
                  Text('Cơ sở khám: $healthCenterName'),
                  const SizedBox(height: 6),
                  Text('Lý do khám: $reason'),
                  const SizedBox(height: 6),
                  Text(
                    'Ngày tạo: $createdAt',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
