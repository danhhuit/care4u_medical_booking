import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/features/doctors/screens/create_medical_record_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/create_prescription_screen.dart';

class DoctorMedicalRecordsScreen extends StatefulWidget {
  const DoctorMedicalRecordsScreen({super.key});

  @override
  State<DoctorMedicalRecordsScreen> createState() =>
      _DoctorMedicalRecordsScreenState();
}

class _DoctorMedicalRecordsScreenState extends State<DoctorMedicalRecordsScreen> {
  int get currentDoctorId => SettingsManager.currentDoctorId;

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
      final data = await _api.getMedicalRecordsByDoctor(currentDoctorId);
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

  Future<void> _openCreateRecord() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateMedicalRecordScreen(
          doctorId: currentDoctorId,
        ),
      ),
    );

    if (created == true) {
      await _loadRecords();
    }
  }



  Future<void> _openCreatePrescription(Map<String, dynamic> record) async {
    final patientId = _toInt(record['patientId']);
    final medicalRecordId = _toInt(record['id']);

    if (patientId == null || medicalRecordId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không lấy được mã bệnh nhân hoặc mã hồ sơ bệnh án'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePrescriptionScreen(
          doctorId: currentDoctorId,
          initialPatientId: patientId,
          initialMedicalRecordId: medicalRecordId,
          lockPatientAndRecord: true,
        ),
      ),
    );

    if (created == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã kê đơn cho hồ sơ bệnh án')),
      );
      await _loadRecords();
    }
  }

  String _text(dynamic value, {String fallback = 'Chưa cập nhật'}) {
    final text = '${value ?? ''}'.trim();
    if (text.isEmpty || text == 'null') return fallback;
    return text;
  }

  String _shortDate(dynamic value) {
    final text = _text(value, fallback: '');
    if (text.length >= 10) return text.substring(0, 10);
    return text.isEmpty ? 'Chưa cập nhật' : text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Hồ sơ bệnh án'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: _loadRecords,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateRecord,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tạo hồ sơ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 56),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
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
          children: [
            const SizedBox(height: 180),
            const Icon(Icons.folder_open, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Chưa có hồ sơ bệnh án',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _openCreateRecord,
                icon: const Icon(Icons.add),
                label: const Text('Tạo hồ sơ đầu tiên'),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRecords,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _records.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final r = _records[index];
          return _recordCard(r);
        },
      ),
    );
  }

  Widget _recordCard(Map<String, dynamic> r) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.12),
          child: const Icon(Icons.description, color: AppColors.primary),
        ),
        title: Text(
          _text(r['diagnosis'], fallback: 'Chẩn đoán chưa cập nhật'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'BN: ${_text(r['patientName'])}\nNgày: ${_shortDate(r['recordDate'])}',
        ),
        children: [
          _info('Mã hồ sơ', _text(r['id'])),
          _info('Mã bệnh nhân', _text(r['patientId'])),
          _info('Mã lịch hẹn', _text(r['appointmentId'])),
          _info('Chuyên khoa', _text(r['specialtyName'])),
          _info('Cơ sở khám', _text(r['healthCenterName'])),
          _info('Lý do khám', _text(r['chiefComplaint'])),
          _info('Triệu chứng', _text(r['symptoms'])),
          _info('Mã ICD-10', _text(r['icd10Code'])),
          _info('Phác đồ điều trị', _text(r['treatmentPlan'])),
          _info('Ngày tái khám', _shortDate(r['followUpDate'])),
          _info('Dấu hiệu sinh tồn', _text(r['vitalSigns'])),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openCreatePrescription(r),
              icon: const Icon(Icons.medication),
              label: const Text('Kê đơn thuốc từ hồ sơ này'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
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
            width: 110,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

}

