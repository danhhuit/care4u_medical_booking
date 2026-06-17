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
  
  // Controllers for the medicine currently being configured
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
  
  // List of added medicines in the prescription
  final List<Map<String, dynamic>> _prescriptionItems = [];

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

  void _addMedicineItem() {
    final quantity = int.tryParse(_quantityController.text.trim());
    if (_selectedMedicineId == null || quantity == null || quantity <= 0) {
      _showError('Vui lòng chọn thuốc và nhập số lượng hợp lệ');
      return;
    }

    final selectedMedicine = _medicines.firstWhere(
      (m) => _toInt(m['id']) == _selectedMedicineId,
    );
    final name = '${selectedMedicine['name'] ?? 'Thuốc'}';
    final dosage = _dosageController.text.trim();
    final frequency = _frequencyController.text.trim();
    final duration = _durationController.text.trim();
    final instructions = _instructionsController.text.trim();

    if (dosage.isEmpty || frequency.isEmpty || duration.isEmpty) {
      _showError('Vui lòng nhập đầy đủ liều dùng, tần suất và thời gian');
      return;
    }

    setState(() {
      _prescriptionItems.add({
        'medicineId': _selectedMedicineId,
        'medicineName': name,
        'dosage': dosage,
        'frequency': frequency,
        'duration': duration,
        'quantity': quantity,
        'instructions': instructions,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã thêm thuốc vào đơn'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _removeMedicineItem(int index) {
    setState(() {
      _prescriptionItems.removeAt(index);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final patientId = int.tryParse(_patientIdController.text.trim());
    final medicalRecordId = int.tryParse(
      _medicalRecordIdController.text.trim(),
    );

    if (patientId == null || medicalRecordId == null) {
      _showError('Vui lòng kiểm tra lại mã bệnh nhân và mã hồ sơ bệnh án');
      return;
    }

    if (_prescriptionItems.isEmpty) {
      _showError('Vui lòng thêm ít nhất một loại thuốc vào đơn thuốc');
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
        items: _prescriptionItems.map((item) {
          return {
            'medicineId': item['medicineId'],
            'dosage': item['dosage'],
            'frequency': item['frequency'],
            'duration': item['duration'],
            'quantity': item['quantity'],
            'instructions': item['instructions'],
          };
        }).toList(),
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
          
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thông tin chung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
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
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thêm thuốc vào đơn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: _selectedMedicineId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Chọn thuốc',
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
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _textField(_dosageController, 'Liều dùng', Icons.local_hospital)),
                      const SizedBox(width: 8),
                      Expanded(child: _textField(_frequencyController, 'Tần suất', Icons.repeat)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _textField(_durationController, 'Thời gian', Icons.date_range)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _numberField(
                          _quantityController,
                          'Số lượng',
                          Icons.format_list_numbered,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _textField(_instructionsController, 'Hướng dẫn sử dụng', Icons.notes),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: _addMedicineItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm loại thuốc này'),
                    ),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Danh sách thuốc đã kê', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  if (_prescriptionItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text('Chưa có thuốc nào được thêm', style: TextStyle(color: Colors.grey))),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _prescriptionItems.length,
                      itemBuilder: (context, index) {
                        final item = _prescriptionItems[index];
                        return Card(
                          color: Colors.grey.shade50,
                          child: ListTile(
                            title: Text('${item['medicineName']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              'Liều: ${item['dosage']} | Tần suất: ${item['frequency']}\n'
                              'Thời gian: ${item['duration']} | SL: ${item['quantity']}\n'
                              'HD: ${item['instructions']}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeMedicineItem(index),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Ghi chú đơn thuốc',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit_note),
              filled: true,
              fillColor: Colors.white,
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
        filled: true,
        fillColor: Colors.white,
      ),
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
        filled: true,
        fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
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

