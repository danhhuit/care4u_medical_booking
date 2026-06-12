import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/features/prescriptions/screens/prescription_detail_page.dart';

class PrescriptionListScreen extends StatefulWidget {
  const PrescriptionListScreen({super.key});

  @override
  State<PrescriptionListScreen> createState() => _PrescriptionListScreenState();
}

class _PrescriptionListScreenState extends State<PrescriptionListScreen> {
  final Care4UApiService _api = Care4UApiService();

  // TODO: Sau này đổi patientId theo tài khoản bệnh nhân đang đăng nhập.
  int get _currentPatientId => SettingsManager.currentPatientId;

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
      final data = await _api.getPrescriptionsByPatient(_currentPatientId);
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

  String _formatDate(dynamic value) {
    final raw = _text(value, fallback: '');
    if (raw.isEmpty) return 'Chưa cập nhật';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
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
          final prescriptionId = int.tryParse('${item['id']}') ?? 0;

          return Card(
            color: cardColor,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: prescriptionId <= 0
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrescriptionDetailScreen(
                            prescriptionId: prescriptionId,
                            initialData: item,
                          ),
                        ),
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.medication, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _text(
                              item['prescriptionNo'],
                              fallback: 'Đơn thuốc',
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Ngày kê: ${_formatDate(item['dateIssued'])}'),
                          Text(
                            'Bác sĩ: ${_text(item['doctorTitle'], fallback: '')} ${_text(item['doctorName'])}'
                                .trim(),
                          ),
                          Text('Số thuốc: ${items.length}'),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
