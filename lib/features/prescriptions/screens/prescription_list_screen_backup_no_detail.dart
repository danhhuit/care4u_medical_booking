import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class PrescriptionListScreen extends StatefulWidget {
  const PrescriptionListScreen({super.key});

  @override
  State<PrescriptionListScreen> createState() => _PrescriptionListScreenState();
}

class _PrescriptionListScreenState extends State<PrescriptionListScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _prescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _api.getPrescriptionsByPatient(4);
      if (!mounted) return;
      setState(() {
        _prescriptions = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải đơn thuốc: $e';
        _isLoading = false;
      });
    }
  }

  String _text(dynamic value, {String fallback = 'Chưa cập nhật'}) {
    final text = '${value ?? ''}'.trim();
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SettingsManager.themeMode,
      builder: (context, mode, _) {
        final isDark =
            mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
        final bgColor = isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF5F7FA);
        final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black87;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: const Text('Đơn thuốc'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: _loadPrescriptions,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: _buildBody(cardColor, textColor),
        );
      },
    );
  }

  Widget _buildBody(Color cardColor, Color textColor) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadPrescriptions,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_prescriptions.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadPrescriptions,
        child: ListView(
          children: const [
            SizedBox(height: 220),
            Center(child: Text('Chưa có đơn thuốc')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPrescriptions,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _prescriptions.length,
        itemBuilder: (context, index) {
          final item = _prescriptions[index];
          final items = (item['items'] as List?) ?? [];

          return Card(
            color: cardColor,
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.medication, color: Colors.white),
              ),
              title: Text(
                _text(item['prescriptionNo'], fallback: 'Đơn thuốc'),
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              subtitle: Text(
                'Ngày kê: ${_text(item['dateIssued'])}\nBác sĩ: ${_text(item['doctorTitle'], fallback: '')} ${_text(item['doctorName'])}',
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                _info('Bệnh nhân', _text(item['patientName'])),
                _info('Trạng thái', _text(item['status'])),
                _info('Ghi chú', _text(item['notes'])),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Danh sách thuốc',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                if (items.isEmpty)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Chưa có thuốc trong đơn'),
                  )
                else
                  ...items.map((raw) {
                    final med = Map<String, dynamic>.from(raw as Map);
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _text(med['medicineName'], fallback: 'Tên thuốc'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Liều dùng: ${_text(med['dosage'])}'),
                          Text('Tần suất: ${_text(med['frequency'])}'),
                          Text('Thời gian: ${_text(med['duration'])}'),
                          Text('Số lượng: ${_text(med['quantity'])}'),
                          Text('Hướng dẫn: ${_text(med['instructions'])}'),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
