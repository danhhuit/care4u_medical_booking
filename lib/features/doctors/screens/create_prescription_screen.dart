import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

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
        _error = '${AppTranslations.tr('cannot_load_medicines')}: $e';
        _isLoadingMedicines = false;
      });
    }
  }

  void _addMedicineItem() {
    final quantity = int.tryParse(_quantityController.text.trim());
    if (_selectedMedicineId == null || quantity == null || quantity <= 0) {
      _showError(AppTranslations.tr('medicine_input_error'));
      return;
    }

    final selectedMedicine = _medicines.firstWhere(
      (m) => _toInt(m['id']) == _selectedMedicineId,
    );
    final name = '${selectedMedicine['name'] ?? 'Medicine'}';
    final dosage = _dosageController.text.trim();
    final frequency = _frequencyController.text.trim();
    final duration = _durationController.text.trim();
    final instructions = _instructionsController.text.trim();

    if (dosage.isEmpty || frequency.isEmpty || duration.isEmpty) {
      _showError(AppTranslations.tr('medicine_input_error'));
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
      SnackBar(
        content: Text(AppTranslations.tr('med_added_success')),
        duration: const Duration(seconds: 1),
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
      _showError(AppTranslations.tr('check_patient_record_id'));
      return;
    }

    if (_prescriptionItems.isEmpty) {
      _showError(AppTranslations.tr('prescription_empty_error'));
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
          content: Text('${result['message'] ?? AppTranslations.tr('create_prescription_success')}'),
          backgroundColor: AppColors.primary,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showError('${AppTranslations.tr('create_prescription_failed')}: $e');
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
    final name = '${medicine['name'] ?? 'Medicine'}';
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
    final isDark = SettingsManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final appBarColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(AppTranslations.tr('create_prescription'), style: TextStyle(color: textColor)),
        centerTitle: true,
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0.5,
      ),
      body: _isLoadingMedicines
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(bgColor, cardColor: isDark ? const Color(0xFF1E1E1E) : Colors.white, textColor: textColor, isDark: isDark),
    );
  }

  Widget _buildForm(Color bgColor, {required Color cardColor, required Color textColor, required bool isDark}) {
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            AppTranslations.tr('no_active_medicines'),
            style: TextStyle(color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final subTextColor = isDark ? Colors.white70 : Colors.black54;

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
              child: Text(
                AppTranslations.tr('prescription_locked_notice'),
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
          
          Card(
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppTranslations.tr('general_info'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                  const SizedBox(height: 12),
                  _numberField(
                    _patientIdController,
                    AppTranslations.tr('patient_code_label'),
                    Icons.person,
                    readOnly: widget.lockPatientAndRecord,
                    isDark: isDark,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 12),
                  _numberField(
                    _medicalRecordIdController,
                    AppTranslations.tr('medical_record_code_label'),
                    Icons.folder_shared,
                    readOnly: widget.lockPatientAndRecord,
                    isDark: isDark,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),

          Card(
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppTranslations.tr('add_medicine_to_prescription'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: _selectedMedicineId,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: AppTranslations.tr('select_medicine'),
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.medication),
                    ),
                    items: _medicines
                        .map((medicine) {
                          final id = _toInt(medicine['id']);
                          return DropdownMenuItem<int>(
                            value: id,
                            child: Text(
                              _medicineLabel(medicine),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: textColor),
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
                      Expanded(child: _textField(_dosageController, AppTranslations.tr('med_dose'), Icons.local_hospital, isDark: isDark, textColor: textColor)),
                      const SizedBox(width: 8),
                      Expanded(child: _textField(_frequencyController, AppTranslations.tr('times_per_day'), Icons.repeat, isDark: isDark, textColor: textColor)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _textField(_durationController, AppTranslations.tr('days_duration'), Icons.date_range, isDark: isDark, textColor: textColor)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _numberField(
                          _quantityController,
                          AppTranslations.tr('total_quantity'),
                          Icons.format_list_numbered,
                          isDark: isDark,
                          textColor: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _textField(_instructionsController, AppTranslations.tr('med_usage'), Icons.notes, isDark: isDark, textColor: textColor),
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
                      label: Text(AppTranslations.tr('add_this_medicine')),
                    ),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppTranslations.tr('prescribed_meds_list'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                  const SizedBox(height: 8),
                  if (_prescriptionItems.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text(AppTranslations.tr('no_meds_prescribed'), style: const TextStyle(color: Colors.grey))),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _prescriptionItems.length,
                      itemBuilder: (context, index) {
                        final item = _prescriptionItems[index];
                        return Card(
                          color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade50,
                          child: ListTile(
                            title: Text('${item['medicineName']}', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                            subtitle: Text(
                              '${AppTranslations.tr('med_dose')}: ${item['dosage']} | ${AppTranslations.tr('times_per_day')}: ${item['frequency']}\n'
                              '${AppTranslations.tr('days_duration')}: ${item['duration']} | SL: ${item['quantity']}\n'
                              '${AppTranslations.tr('med_usage')}: ${item['instructions']}',
                              style: TextStyle(fontSize: 13, color: subTextColor),
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
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: AppTranslations.tr('prescription_notes'),
              labelStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.edit_note),
              filled: true,
              fillColor: cardColor,
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
              label: Text(_isSaving ? AppTranslations.tr('saving_label') : AppTranslations.tr('save_prescription')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label,
    IconData icon, {
    required bool isDark,
    required Color textColor,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      ),
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool readOnly = false,
    required bool isDark,
    required Color textColor,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      readOnly: readOnly,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: readOnly
            ? (isDark ? const Color(0xFF2E2E2E) : Colors.grey.shade100)
            : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return AppTranslations.tr('field_required');
        if (int.tryParse(value.trim()) == null) return AppTranslations.tr('must_be_number');
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
