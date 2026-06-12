import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';

class CreateMedicalRecordScreen extends StatefulWidget {
  final int doctorId;

  const CreateMedicalRecordScreen({super.key, required this.doctorId});

  @override
  State<CreateMedicalRecordScreen> createState() =>
      _CreateMedicalRecordScreenState();
}

class _CreateMedicalRecordScreenState extends State<CreateMedicalRecordScreen> {
  final Care4UApiService _api = Care4UApiService();
  final _formKey = GlobalKey<FormState>();

  final _appointmentIdController = TextEditingController();
  final _patientIdController = TextEditingController();
  final _recordDateController = TextEditingController();
  final _chiefComplaintController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _icd10Controller = TextEditingController();
  final _treatmentPlanController = TextEditingController();
  final _followUpDateController = TextEditingController();
  final _vitalSignsController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  String? _selectedAppointmentId;
  List<Map<String, dynamic>> _availableAppointments = [];

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _recordDateController.text = _formatDate(today);
    _followUpDateController.text = _formatDate(
      today.add(const Duration(days: 14)),
    );
    _loadAvailableAppointments();
  }

  @override
  void dispose() {
    _appointmentIdController.dispose();
    _patientIdController.dispose();
    _recordDateController.dispose();
    _chiefComplaintController.dispose();
    _symptomsController.dispose();
    _diagnosisController.dispose();
    _icd10Controller.dispose();
    _treatmentPlanController.dispose();
    _followUpDateController.dispose();
    _vitalSignsController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableAppointments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final appointments = await _api.getAppointments();
      final records = await _api.getMedicalRecordsByDoctor(widget.doctorId);

      final usedAppointmentIds = records
          .map((r) => '${r['appointmentId'] ?? ''}'.trim().toLowerCase())
          .where((id) => id.isNotEmpty && id != 'null')
          .toSet();

      final available = appointments.where((a) {
        final doctorId = _toInt(a['doctorId']);
        final appointmentId = '${a['id'] ?? ''}'.trim().toLowerCase();
        return doctorId == widget.doctorId &&
            appointmentId.isNotEmpty &&
            !usedAppointmentIds.contains(appointmentId);
      }).toList();

      if (!mounted) return;
      setState(() {
        _availableAppointments = available;
        _isLoading = false;
      });

      if (available.isNotEmpty) {
        _selectAppointment(available.first);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải lịch hẹn chưa có hồ sơ bệnh án: $e';
        _isLoading = false;
      });
    }
  }

  void _selectAppointment(Map<String, dynamic> appointment) {
    final appointmentId = '${appointment['id'] ?? ''}';
    final patientId = '${appointment['patientId'] ?? ''}';
    final reason = '${appointment['reason'] ?? ''}'.trim();

    setState(() {
      _selectedAppointmentId = appointmentId;
      _appointmentIdController.text = appointmentId;
      _patientIdController.text = patientId;
      if (_chiefComplaintController.text.trim().isEmpty &&
          reason.isNotEmpty &&
          reason != 'null') {
        _chiefComplaintController.text = reason;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final patientId = int.tryParse(_patientIdController.text.trim());
    if (patientId == null || _selectedAppointmentId == null) {
      _showError('Vui lòng chọn lịch hẹn hợp lệ');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final result = await _api.createMedicalRecord(
        appointmentId: _selectedAppointmentId!,
        patientId: patientId,
        doctorId: widget.doctorId,
        recordDate: _recordDateController.text.trim(),
        chiefComplaint: _chiefComplaintController.text.trim(),
        symptoms: _emptyToNull(_symptomsController.text),
        diagnosis: _diagnosisController.text.trim(),
        icd10Code: _emptyToNull(_icd10Controller.text),
        treatmentPlan: _emptyToNull(_treatmentPlanController.text),
        followUpDate: _emptyToNull(_followUpDateController.text),
        vitalSigns: _emptyToNull(_vitalSignsController.text),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${result['message'] ?? 'Tạo hồ sơ bệnh án thành công'}',
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showError('Tạo hồ sơ thất bại: $e');
    }
  }

  String? _emptyToNull(String value) {
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 6),
      ),
    );
  }

  String _formatDate(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }

  String _appointmentLabel(Map<String, dynamic> a) {
    final no = '${a['appointmentNo'] ?? 'Lịch hẹn'}';
    final patient = '${a['patientName'] ?? 'BN #${a['patientId'] ?? ''}'}';
    return '$no - $patient';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Tạo hồ sơ bệnh án'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadAvailableAppointments,
            icon: const Icon(Icons.refresh),
          ),
        ],
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
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadAvailableAppointments,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_availableAppointments.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadAvailableAppointments,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            SizedBox(height: 160),
            Icon(Icons.event_busy, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Không còn lịch hẹn nào chưa có hồ sơ bệnh án.\nHãy tạo lịch hẹn mới hoặc kiểm tra lại danh sách hồ sơ.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: _selectedAppointmentId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Chọn lịch hẹn chưa có hồ sơ',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.event_available),
            ),
            items: _availableAppointments.map((a) {
              final id = '${a['id'] ?? ''}';
              return DropdownMenuItem<String>(
                value: id,
                child: Text(
                  _appointmentLabel(a),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              final appointment = _availableAppointments.firstWhere(
                (a) => '${a['id'] ?? ''}' == value,
              );
              _selectAppointment(appointment);
            },
            validator: (value) => value == null || value.isEmpty
                ? 'Vui lòng chọn lịch hẹn'
                : null,
          ),
          const SizedBox(height: 12),
          _readonlyField(_appointmentIdController, 'Mã lịch hẹn', Icons.event),
          const SizedBox(height: 12),
          _readonlyField(_patientIdController, 'Mã bệnh nhân', Icons.person),
          const SizedBox(height: 12),
          _textField(
            _recordDateController,
            'Ngày lập hồ sơ',
            Icons.calendar_today,
          ),
          const SizedBox(height: 12),
          _textField(
            _chiefComplaintController,
            'Lý do khám',
            Icons.medical_services,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          _textField(
            _symptomsController,
            'Triệu chứng',
            Icons.sick,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          _textField(
            _diagnosisController,
            'Chẩn đoán',
            Icons.assignment_turned_in,
            required: true,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          _textField(_icd10Controller, 'Mã ICD-10', Icons.code),
          const SizedBox(height: 12),
          _textField(
            _treatmentPlanController,
            'Phác đồ điều trị',
            Icons.healing,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          _textField(
            _followUpDateController,
            'Ngày tái khám',
            Icons.event_repeat,
          ),
          const SizedBox(height: 12),
          _textField(
            _vitalSignsController,
            'Dấu hiệu sinh tồn',
            Icons.monitor_heart,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? 'Đang lưu...' : 'Lưu hồ sơ bệnh án'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readonlyField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return 'Không được để trống';
        }
        return null;
      },
    );
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }
}
