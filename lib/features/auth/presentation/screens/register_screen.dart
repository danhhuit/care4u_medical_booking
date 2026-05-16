import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';

import 'package:care4u_medical_booking/core/database/app_database.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  void _handleRegister() async {
    final account = _accountController.text.trim();
    final password = _passwordController.text.trim();
    final rePassword = _rePasswordController.text.trim();

    if (account.isEmpty || password.isEmpty || rePassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    if (password != rePassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu nhập lại không khớp')),
      );
      return;
    }

    // Check account format
    bool isEmail = account.contains('@');
    bool isPhoneOnlyDigits = RegExp(r'^\d+$').hasMatch(account);

    if (isPhoneOnlyDigits) {
      if (account.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Số điện thoại không hợp lệ')),
        );
        return;
      }
    } else {
      // If not phone, check if it's a vaguely valid email structure
      if (!isEmail) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Định dạng tài khoản không hợp lệ')),
        );
        return;
      }
    }

    // Password validation: exactly 6 digits
    if (!RegExp(r'^\d{6}$').hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu không hợp lệ')),
      );
      return;
    }

    // Save to AppDatabase
    bool success = await AppDatabase.instance.registerUser(account, password);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng kí thành công')),
      );
      Navigator.pop(context); // Go back to login screen
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tài khoản đã tồn tại')),
      );
    }
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              const Text('Chào mừng đến với Care4U', style: AppTextStyles.heading2),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Vui lòng nhập email hoặc số điện thoại của bạn\nđể đăng kí tài khoản',
                style: AppTextStyles.bodyLight,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Care4uTextField(
                controller: _accountController,
                hintText: 'Nhập email hoặc số điện thoại của bạn',
              ),
              const SizedBox(height: AppSpacing.lg),
              Care4uTextField(
                controller: _passwordController,
                hintText: 'Nhập mật khẩu đăng nhập (6 kí tự số)',
                isPassword: true,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.lg),
              Care4uTextField(
                controller: _rePasswordController,
                hintText: 'Nhập lại mật khẩu',
                isPassword: true,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.xl),
              Care4uButton(
                text: 'Đăng kí',
                onPressed: _handleRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}