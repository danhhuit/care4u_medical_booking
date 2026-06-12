import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _showRePassword = false;

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

  Future<void> _handleRegister() async {
    if (_isLoading) return;

    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final phone = _normalizePhone(_phoneController.text);
    final password = _passwordController.text.trim();
    final rePassword = _rePasswordController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        rePassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email không hợp lệ')));
      return;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số điện thoại phải gồm 10 chữ số')),
      );
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu phải gồm 6 chữ số')),
      );
      return;
    }

    if (password != rePassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu nhập lại không khớp')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _api.registerPatient(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        gender: 'M',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công. Vui lòng đăng nhập.'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đăng ký thất bại: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.lg),

              Image.asset('assests/images/logo.png', height: 60),

              const SizedBox(height: AppSpacing.lg),

              const Text(
                'Chào mừng đến với Care4U',
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: AppSpacing.xs),

              const Text(
                'Vui lòng nhập thông tin để đăng ký tài khoản bệnh nhân',
                style: AppTextStyles.bodyLight,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xxxl),

              Care4uTextField(
                controller: _fullNameController,
                hintText: 'Nhập họ và tên',
              ),

              const SizedBox(height: AppSpacing.lg),

              Care4uTextField(
                controller: _emailController,
                hintText: 'Nhập email',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: AppSpacing.lg),

              Care4uTextField(
                controller: _phoneController,
                hintText: 'Nhập số điện thoại',
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: AppSpacing.lg),

              _passwordField(
                controller: _passwordController,
                hintText: 'Nhập mật khẩu đăng nhập (6 chữ số)',
                isVisible: _showPassword,
                onToggle: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              _passwordField(
                controller: _rePasswordController,
                hintText: 'Nhập lại mật khẩu',
                isVisible: _showRePassword,
                onToggle: () {
                  setState(() {
                    _showRePassword = !_showRePassword;
                  });
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              Care4uButton(
                text: _isLoading ? 'Đang đăng ký...' : 'Đăng ký',
                onPressed: () {
                  if (_isLoading) return;
                  _handleRegister();
                },
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
