import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';

class AdminUserDetailScreen extends StatefulWidget {
  final String userId;

  const AdminUserDetailScreen({super.key, required this.userId});

  @override
  State<AdminUserDetailScreen> createState() => _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = false;
  bool _isSaving = false;
  bool _isActive = true;

  String _role = '';

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _newPasswordController = TextEditingController();

  final _fullNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();

  final _bloodTypeController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  final _titleController = TextEditingController();
  final _licenseController = TextEditingController();
  final _consultationFeeController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  String _text(dynamic value) {
    if (value == null) return '';
    if ('$value' == 'null') return '';
    return '$value';
  }

  String _dateOnly(dynamic value) {
    final text = _text(value);
    if (text.length >= 10) {
      return text.substring(0, 10);
    }
    return text;
  }

  Future<void> _loadDetail() async {
    setState(() => _isLoading = true);

    try {
      final data = await _api.getAdminUserDetail(widget.userId);

      final user = Map<String, dynamic>.from(data['user'] as Map);
      final profile = data['profile'] is Map
          ? Map<String, dynamic>.from(data['profile'] as Map)
          : <String, dynamic>{};

      _role = _text(user['role']);
      _isActive = user['isActive'] == true;

      _emailController.text = _text(user['email']);
      _phoneController.text = _text(user['phone']);

      _fullNameController.text = _text(profile['fullName']);
      _genderController.text = _text(profile['gender']);
      _dobController.text = _dateOnly(profile['dob']);
      _addressController.text = _text(profile['address']);

      _bloodTypeController.text = _text(profile['bloodType']);
      _allergiesController.text = _text(profile['allergies']);
      _emergencyNameController.text = _text(profile['emergencyContactName']);
      _emergencyPhoneController.text = _text(profile['emergencyContactPhone']);

      _titleController.text = _text(profile['title']);
      _licenseController.text = _text(profile['licenseNumber']);
      _consultationFeeController.text = _text(profile['consultationFee']);
      _bioController.text = _text(profile['bio']);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${AppTranslations.tr('load_detail_failed')}: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _normalizePhone(String value) {
    var phone = value.trim().replaceAll(' ', '').replaceAll('-', '');

    if (phone.startsWith('+84')) {
      phone = '0${phone.substring(3)}';
    }

    if (phone.startsWith('84') && phone.length == 11) {
      phone = '0${phone.substring(2)}';
    }

    return phone;
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final email = _emailController.text.trim().toLowerCase();
    final phone = _normalizePhone(_phoneController.text);
    final newPassword = _newPasswordController.text.trim();

    if (email.isEmpty) {
      _showMessage(AppTranslations.tr('email_empty_error'));
      return;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showMessage(AppTranslations.tr('email_invalid_error'));
      return;
    }

    if (phone.isNotEmpty && !RegExp(r'^\d{10}$').hasMatch(phone)) {
      _showMessage(AppTranslations.tr('phone_length_error'));
      return;
    }

    if (newPassword.isNotEmpty && !RegExp(r'^\d{6}$').hasMatch(newPassword)) {
      _showMessage(AppTranslations.tr('password_length_error'));
      return;
    }

    if (_role == 'doctor') {
      final license = _licenseController.text.trim().toUpperCase();

      if (license.isNotEmpty && !RegExp(r'^LIC-\d{6}$').hasMatch(license)) {
        _showMessage(AppTranslations.tr('license_format_error'));
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      await _api.updateAdminUser(
        userId: widget.userId,
        email: email,
        phone: phone,
        newPassword: newPassword.isEmpty ? null : newPassword,
        fullName: _fullNameController.text.trim(),
        gender: _genderController.text.trim(),
        dob: _dobController.text.trim(),
        address: _addressController.text.trim(),
        bloodType: _bloodTypeController.text.trim(),
        allergies: _allergiesController.text.trim(),
        emergencyContactName: _emergencyNameController.text.trim(),
        emergencyContactPhone: _emergencyPhoneController.text.trim(),
        title: _titleController.text.trim(),
        licenseNumber: _licenseController.text.trim(),
        consultationFee: double.tryParse(
          _consultationFeeController.text.trim(),
        ),
        bio: _bioController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppTranslations.tr('update_account_success'))),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _showMessage('${AppTranslations.tr('update_account_failed')}: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _toggleStatus() async {
    final nextActive = !_isActive;

    try {
      await _api.updateAdminUserStatus(
        userId: widget.userId,
        isActive: nextActive,
      );

      if (!mounted) return;

      setState(() {
        _isActive = nextActive;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            nextActive ? AppTranslations.tr('unlocked_account_msg') : AppTranslations.tr('locked_account_msg'),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage('${AppTranslations.tr('update_status_failed')}: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? helperText,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: subTextColor),
          helperText: helperText,
          helperStyle: TextStyle(color: subTextColor.withOpacity(0.8), fontSize: 11),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: subTextColor.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 12),
      child: Text(
        text,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textColor),
      ),
    );
  }

  Widget _buildStatusCard(Color cardColor, Color textColor, Color subTextColor) {
    return Card(
      color: cardColor,
      child: SwitchListTile(
        title: Text(
          AppTranslations.tr('account_status'),
          style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
        ),
        subtitle: Text(
          _isActive
              ? AppTranslations.tr('account_status_active_desc')
              : AppTranslations.tr('account_status_locked_desc'),
          style: TextStyle(color: subTextColor),
        ),
        value: _isActive,
        activeColor: Colors.green,
        inactiveThumbColor: Colors.red,
        onChanged: (_) => _toggleStatus(),
      ),
    );
  }

  Widget _buildCommonFields(Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(AppTranslations.tr('account_info_section'), textColor),
        _field(
          'Email',
          _emailController,
          keyboardType: TextInputType.emailAddress,
          textColor: textColor,
          subTextColor: subTextColor,
        ),
        _field(
          AppTranslations.tr('phone_label'),
          _phoneController,
          keyboardType: TextInputType.phone,
          textColor: textColor,
          subTextColor: subTextColor,
        ),
        _field(
          AppTranslations.tr('new_password_label'),
          _newPasswordController,
          keyboardType: TextInputType.number,
          helperText: AppTranslations.tr('new_password_helper'),
          textColor: textColor,
          subTextColor: subTextColor,
        ),
        _sectionTitle(AppTranslations.tr('personal_info_section'), textColor),
        _field(AppTranslations.tr('fullname_label'), _fullNameController, textColor: textColor, subTextColor: subTextColor),
      ],
    );
  }

  Widget _buildPatientFields(Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field(
          AppTranslations.tr('gender_label'),
          _genderController,
          helperText: AppTranslations.tr('gender_helper'),
          textColor: textColor,
          subTextColor: subTextColor,
        ),
        _field(
          AppTranslations.tr('dob_label'),
          _dobController,
          keyboardType: TextInputType.datetime,
          helperText: AppTranslations.tr('dob_helper'),
          textColor: textColor,
          subTextColor: subTextColor,
        ),
        _field(AppTranslations.tr('address_label'), _addressController, textColor: textColor, subTextColor: subTextColor),
        _field(AppTranslations.tr('blood_group_label'), _bloodTypeController, textColor: textColor, subTextColor: subTextColor),
        _field(AppTranslations.tr('allergies_label'), _allergiesController, maxLines: 2, textColor: textColor, subTextColor: subTextColor),
        _field(AppTranslations.tr('emergency_name_label'), _emergencyNameController, textColor: textColor, subTextColor: subTextColor),
        _field(
          AppTranslations.tr('emergency_phone_label'),
          _emergencyPhoneController,
          keyboardType: TextInputType.phone,
          textColor: textColor,
          subTextColor: subTextColor,
        ),
      ],
    );
  }

  Widget _buildDoctorFields(Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field(AppTranslations.tr('title_label'), _titleController, textColor: textColor, subTextColor: subTextColor),
        _field(
          AppTranslations.tr('license_number'),
          _licenseController,
          helperText: AppTranslations.tr('license_helper'),
          textColor: textColor,
          subTextColor: subTextColor,
        ),
        _field(
          AppTranslations.tr('consultation_fee_label'),
          _consultationFeeController,
          keyboardType: TextInputType.number,
          textColor: textColor,
          subTextColor: subTextColor,
        ),
        _field(AppTranslations.tr('bio_label'), _bioController, maxLines: 4, textColor: textColor, subTextColor: subTextColor),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _newPasswordController.dispose();
    _fullNameController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _titleController.dispose();
    _licenseController.dispose();
    _consultationFeeController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = SettingsManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    final roleText = _role == 'doctor'
        ? AppTranslations.tr('doctor_label')
        : _role == 'patient'
        ? AppTranslations.tr('patient_label')
        : _role == 'admin'
        ? AppTranslations.tr('admin_label')
        : _role;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('${AppTranslations.tr('account_detail_title')} $roleText'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await SettingsManager.toggleTheme(!isDark);
              setState(() {});
            },
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
          IconButton(onPressed: _loadDetail, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStatusCard(cardColor, textColor, subTextColor),
                  const SizedBox(height: 12),
                  _buildCommonFields(textColor, subTextColor),
                  if (_role == 'patient') _buildPatientFields(textColor, subTextColor),
                  if (_role == 'doctor') _buildDoctorFields(textColor, subTextColor),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.save),
                      label: Text(_isSaving ? AppTranslations.tr('saving_label') : AppTranslations.tr('save_update_label')),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
