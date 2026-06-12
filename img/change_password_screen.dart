import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final Care4UApiService _api = Care4UApiService();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;

  bool _isGuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }

  String _getCurrentUserId() {
    final value = (SettingsManager.currentUserId ??
            SettingsManager.currentPatientUserId ??
            '')
        .trim();

    if (!_isGuid(value)) {
      return '';
    }

    return value;
  }

  Future<void> _handleChangePassword() async {
    final userId = _getCurrentUserId();

    debugPrint('CHANGE PASSWORD USER ID: $userId');

    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (userId.isEmpty) {
      _showMessage(
        'Không tìm thấy mã người dùng hợp lệ. Vui lòng đăng xuất và đăng nhập lại.',
      );
      return;
    }

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Vui lòng nhập đầy đủ thông tin');
      return;
    }

    if (newPassword.length < 6) {
      _showMessage('Mật khẩu mới phải có ít nhất 6 ký tự');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('Mật khẩu nhập lại không khớp');
      return;
    }

    if (oldPassword == newPassword) {
      _showMessage('Mật khẩu mới không được trùng mật khẩu hiện tại');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _api.changePassword(
        userId: userId,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (!mounted) return;

      _showMessage('${result['message'] ?? 'Đổi mật khẩu thành công'}');

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      final message = e.toString().replaceFirst('Exception: ', '');
      _showMessage('Đổi mật khẩu thất bại: $message');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Cập nhật mật khẩu đăng nhập của bạn',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vui lòng nhập mật khẩu hiện tại và mật khẩu mới.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          _passwordField(
            controller: _oldPasswordController,
            label: 'Mật khẩu hiện tại',
            visible: _showOld,
            onToggle: () => setState(() => _showOld = !_showOld),
          ),
          const SizedBox(height: 16),

          _passwordField(
            controller: _newPasswordController,
            label: 'Mật khẩu mới',
            visible: _showNew,
            onToggle: () => setState(() => _showNew = !_showNew),
          ),
          const SizedBox(height: 16),

          _passwordField(
            controller: _confirmPasswordController,
            label: 'Nhập lại mật khẩu mới',
            visible: _showConfirm,
            onToggle: () => setState(() => _showConfirm = !_showConfirm),
          ),
          const SizedBox(height: 28),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _isLoading ? null : _handleChangePassword,
              child: Text(
                _isLoading ? 'Đang xử lý...' : 'Đổi mật khẩu',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
