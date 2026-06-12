import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
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
      ).showSnackBar(SnackBar(content: Text('Tải chi tiết thất bại: $e')));
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
      _showMessage('Email không được để trống');
      return;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showMessage('Email không hợp lệ');
      return;
    }

    if (phone.isNotEmpty && !RegExp(r'^\d{10}$').hasMatch(phone)) {
      _showMessage('Số điện thoại phải gồm 10 chữ số');
      return;
    }

    if (newPassword.isNotEmpty && !RegExp(r'^\d{6}$').hasMatch(newPassword)) {
      _showMessage('Mật khẩu mới phải gồm 6 chữ số');
      return;
    }

    if (_role == 'doctor') {
      final license = _licenseController.text.trim().toUpperCase();

      if (license.isNotEmpty && !RegExp(r'^LIC-\d{6}$').hasMatch(license)) {
        _showMessage('Mã định danh phải có dạng LIC-001234');
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
        const SnackBar(content: Text('Cập nhật tài khoản thành công')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _showMessage('Cập nhật thất bại: $e');
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
            nextActive ? 'Đã mở khóa tài khoản' : 'Đã khóa tài khoản',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage('Cập nhật trạng thái thất bại: $e');
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: SwitchListTile(
        title: const Text(
          'Trạng thái tài khoản',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          _isActive
              ? 'Tài khoản đang được phép đăng nhập'
              : 'Tài khoản đang bị khóa, không thể đăng nhập',
        ),
        value: _isActive,
        activeColor: Colors.green,
        inactiveThumbColor: Colors.red,
        onChanged: (_) => _toggleStatus(),
      ),
    );
  }

  Widget _buildCommonFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Thông tin tài khoản'),
        _field(
          'Email',
          _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        _field(
          'Số điện thoại',
          _phoneController,
          keyboardType: TextInputType.phone,
        ),
        _field(
          'Mật khẩu mới',
          _newPasswordController,
          keyboardType: TextInputType.number,
          helperText: 'Để trống nếu không muốn đổi mật khẩu',
        ),
        _sectionTitle('Thông tin cá nhân'),
        _field('Họ tên', _fullNameController),
      ],
    );
  }

  Widget _buildPatientFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field(
          'Giới tính',
          _genderController,
          helperText: 'M = Nam, F = Nữ, O = Khác',
        ),
        _field(
          'Ngày sinh',
          _dobController,
          keyboardType: TextInputType.datetime,
          helperText: 'Định dạng: yyyy-MM-dd',
        ),
        _field('Địa chỉ', _addressController),
        _field('Nhóm máu', _bloodTypeController),
        _field('Dị ứng', _allergiesController, maxLines: 2),
        _field('Người liên hệ khẩn cấp', _emergencyNameController),
        _field(
          'SĐT liên hệ khẩn cấp',
          _emergencyPhoneController,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildDoctorFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field('Học hàm / Chức danh', _titleController),
        _field(
          'Mã định danh nghề nghiệp',
          _licenseController,
          helperText: 'Ví dụ: LIC-001234',
        ),
        _field(
          'Phí tư vấn',
          _consultationFeeController,
          keyboardType: TextInputType.number,
        ),
        _field('Tiểu sử / Mô tả', _bioController, maxLines: 4),
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
    final roleText = _role == 'doctor'
        ? 'Bác sĩ'
        : _role == 'patient'
        ? 'Bệnh nhân'
        : _role == 'admin'
        ? 'Admin'
        : _role;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Chi tiết tài khoản $roleText'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _loadDetail, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 12),
                  _buildCommonFields(),
                  if (_role == 'patient') _buildPatientFields(),
                  if (_role == 'doctor') _buildDoctorFields(),
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
                      label: Text(_isSaving ? 'Đang lưu...' : 'Lưu cập nhật'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
