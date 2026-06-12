import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';

class CreatePrescriptionScreen extends StatefulWidget {
  final int doctorId;
  final int? initialPatientId;
  final int? initialMedicalRecordId;
  final bool lockPatientAndRecord;

  const CreatePrescriptionScreen({
    super.key,
    required this.doctorId,
    this.initialPatientId,
    this.initialMedicalRecordId,
    this.lockPatientAndRecord = false,
  });

  @override
  State<CreatePrescriptionScreen> createState() =>
      _CreatePrescriptionScreenState();
}

class _CreatePrescriptionScreenState extends State<CreatePrescriptionScreen> {
  final Care4UApiService _api = Care4UApiService();

  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _medicalRecordIdController = TextEditingController();
  final _dosageController = TextEditingController(text: '1 viên');
  final _frequencyController = TextEditingController(text: '2 lần/ngày');
  final _durationController = TextEditingController(text: '7 ngày');
  final _quantityController = TextEditingController(text: '14');
  final _instructionsController = TextEditingController(text: 'Uống sau ăn');
  final _notesController = TextEditingController();

  bool _isLoadingMedicines = true;
  bool _isSaving = false;
  String? _error;
  int? _selectedMedicineId;
  List<Map<String, dynamic>> _medicines = [];

  @override
  void initState() {
    super.initState();
    _patientIdController.text = '${widget.initialPatientId ?? 1}';
    _medicalRecordIdController.text = '${widget.initialMedicalRecordId ?? 1}';
    _loadMedicines();
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _medicalRecordIdController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _quantityController.dispose();
    _instructionsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadMedicines() async {
    try {
      final data = await _api.getMedicines();
      if (!mounted) return;
      setState(() {
        _medicines = data;
        _selectedMedicineId = data.isNotEmpty ? _toInt(data.first['id']) : null;
        _isLoadingMedicines = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải danh sách thuốc: $e';
        _isLoadingMedicines = false;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final patientId = int.tryParse(_patientIdController.text.trim());
    final medicalRecordId = int.tryParse(
      _medicalRecordIdController.text.trim(),
    );
    final quantity = int.tryParse(_quantityController.text.trim());

    if (patientId == null ||
        medicalRecordId == null ||
        quantity == null ||
        _selectedMedicineId == null) {
      _showError('Vui lòng kiểm tra lại thông tin kê đơn');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final result = await _api.createPrescription(
        medicalRecordId: medicalRecordId,
        doctorId: widget.doctorId,
        patientId: patientId,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        items: [
          {
            'medicineId': _selectedMedicineId,
            'dosage': _dosageController.text.trim(),
            'frequency': _frequencyController.text.trim(),
            'duration': _durationController.text.trim(),
            'quantity': quantity,
            'instructions': _instructionsController.text.trim(),
          },
        ],
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result['message'] ?? 'Tạo đơn thuốc thành công'}'),
          backgroundColor: AppColors.primary,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showError('Tạo đơn thuốc thất bại: $e');
    }
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

  String _medicineLabel(Map<String, dynamic> medicine) {
    final name = '${medicine['name'] ?? 'Thuốc'}';
    final strength = '${medicine['strength'] ?? ''}'.trim();
    final form = '${medicine['dosageForm'] ?? ''}'.trim();
    final extra = [
      strength,
      form,
    ].where((x) => x.isNotEmpty && x != 'null').join(' - ');
    return extra.isEmpty ? name : '$name ($extra)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Kê đơn thuốc'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: _isLoadingMedicines
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_medicines.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Chưa có thuốc đang hoạt động trong database. Hãy thêm dữ liệu vào bảng medicines trước.',
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.lockPatientAndRecord)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Đơn thuốc này được tạo từ hồ sơ bệnh án đã chọn. Mã bệnh nhân và mã hồ sơ được khóa để tránh nhập sai.',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          _numberField(
            _patientIdController,
            'Mã bệnh nhân',
            Icons.person,
            readOnly: widget.lockPatientAndRecord,
          ),
          const SizedBox(height: 12),
          _numberField(
            _medicalRecordIdController,
            'Mã hồ sơ bệnh án',
            Icons.folder_shared,
            readOnly: widget.lockPatientAndRecord,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: _selectedMedicineId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Thuốc',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.medication),
            ),
            items: _medicines
                .map((medicine) {
                  final id = _toInt(medicine['id']);
                  return DropdownMenuItem<int>(
                    value: id,
                    child: Text(
                      _medicineLabel(medicine),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                })
                .where((item) => item.value != null)
                .toList(),
            onChanged: (value) => setState(() => _selectedMedicineId = value),
            validator: (value) => value == null ? 'Vui lòng chọn thuốc' : null,
          ),
          const SizedBox(height: 12),
          _textField(_dosageController, 'Liều dùng', Icons.local_hospital),
          const SizedBox(height: 12),
          _textField(_frequencyController, 'Tần suất', Icons.repeat),
          const SizedBox(height: 12),
          _textField(_durationController, 'Thời gian dùng', Icons.date_range),
          const SizedBox(height: 12),
          _numberField(
            _quantityController,
            'Số lượng',
            Icons.format_list_numbered,
          ),
          const SizedBox(height: 12),
          _textField(_instructionsController, 'Hướng dẫn sử dụng', Icons.notes),
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Ghi chú đơn thuốc',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit_note),
            ),
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
              label: Text(_isSaving ? 'Đang lưu...' : 'Lưu đơn thuốc'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Không được để trống' : null,
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        filled: readOnly,
        fillColor: readOnly ? Colors.grey.shade100 : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Không được để trống';
        if (int.tryParse(value.trim()) == null) return 'Phải là số';
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
