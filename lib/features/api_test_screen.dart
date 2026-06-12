import 'package:flutter/material.dart';
import '../core/api/care4u_api_service.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = false;
  String _message = 'Bấm nút bên dưới để test toàn bộ API';
  final Map<String, List<Map<String, dynamic>>> _data = {};

  Future<void> _testAllApis() async {
    setState(() {
      _isLoading = true;
      _message = 'Đang gọi API...';
      _data.clear();
    });

    try {
      final doctors = await _api.getDoctors();
      final specialties = await _api.getSpecialties();
      final patients = await _api.getPatients();
      final products = await _api.getStoreProducts();
      final appointments = await _api.getAppointments();

      setState(() {
        _data['Doctors'] = doctors;
        _data['Specialties'] = specialties;
        _data['Patients'] = patients;
        _data['StoreProducts'] = products;
        _data['Appointments'] = appointments;

        _message = 'Kết nối API thành công! Tất cả endpoint đều trả dữ liệu.';
      });
    } catch (e) {
      setState(() {
        _message = 'Có lỗi khi gọi API:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildApiSection(String title, List<Map<String, dynamic>> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          '$title (${items.length})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(items.isEmpty ? 'Không có dữ liệu hoặc bảng đang trống' : 'Đã lấy dữ liệu thành công'),
        children: [
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('[]'),
            )
          else
            ...items.take(5).map(
                  (item) => ListTile(
                    title: Text(_getTitle(title, item)),
                    subtitle: Text(item.toString()),
                  ),
                ),
        ],
      ),
    );
  }

  static String _getTitle(String type, Map<String, dynamic> item) {
    switch (type) {
      case 'Doctors':
        return '${item['fullName'] ?? 'Không tên'} - ${item['specialtyName'] ?? ''}';
      case 'Specialties':
        return '${item['name'] ?? 'Không tên'}';
      case 'Patients':
        return '${item['fullName'] ?? 'Không tên'}';
      case 'StoreProducts':
        return '${item['name'] ?? 'Không tên'}';
      case 'Appointments':
        return '${item['appointmentNo'] ?? item['id'] ?? 'Lịch hẹn'}';
      default:
        return item.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Care4U API Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _testAllApis,
                icon: const Icon(Icons.cloud_sync),
                label: const Text('TEST TOÀN BỘ API'),
              ),
            ),
            const SizedBox(height: 12),
            if (_isLoading) const LinearProgressIndicator(),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _message,
                style: TextStyle(
                  color: _message.contains('lỗi') || _message.contains('Lỗi')
                      ? Colors.red
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _data.isEmpty
                  ? const Center(
                      child: Text('Chưa có dữ liệu API'),
                    )
                  : ListView(
                      children: _data.entries
                          .map((entry) => _buildApiSection(entry.key, entry.value))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
