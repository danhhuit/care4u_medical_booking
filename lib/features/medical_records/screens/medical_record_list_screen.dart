import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class MedicalRecordListScreen extends StatefulWidget {
  const MedicalRecordListScreen({super.key});

  @override
  State<MedicalRecordListScreen> createState() =>
      _MedicalRecordListScreenState();
}

class _MedicalRecordListScreenState extends State<MedicalRecordListScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _api.getMedicalRecordsByPatient(
        SettingsManager.currentPatientId,
      );
      if (!mounted) return;
      setState(() {
        _records = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải hồ sơ bệnh án: $e';
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
            title: const Text('Hồ sơ bệnh án'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: _loadRecords,
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
                onPressed: _loadRecords,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_records.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadRecords,
        child: ListView(
          children: const [
            SizedBox(height: 220),
            Center(child: Text('Chưa có hồ sơ bệnh án')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRecords,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _records.length,
        itemBuilder: (context, index) {
          final item = _records[index];

          return Card(
            color: cardColor,
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.folder_open, color: Colors.white),
              ),
              title: Text(
                _text(item['diagnosis'], fallback: 'Chẩn đoán chưa cập nhật'),
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              subtitle: Text(
                'Ngày khám: ${_text(item['recordDate'])}\nBác sĩ: ${_text(item['doctorTitle'], fallback: '')} ${_text(item['doctorName'])}',
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                _info('Bệnh nhân', _text(item['patientName'])),
                _info('Chuyên khoa', _text(item['specialtyName'])),
                _info('Cơ sở khám', _text(item['healthCenterName'])),
                _info('Lý do khám', _text(item['chiefComplaint'])),
                _info('Triệu chứng', _text(item['symptoms'])),
                _info('Mã ICD-10', _text(item['icd10Code'])),
                _info('Phác đồ điều trị', _text(item['treatmentPlan'])),
                _info('Ngày tái khám', _text(item['followUpDate'])),
                _info('Dấu hiệu sinh tồn', _text(item['vitalSigns'])),
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
