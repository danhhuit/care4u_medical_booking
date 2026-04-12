import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/core/database/app_database.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String account;
  
  const ResetPasswordScreen({Key? key, required this.account}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu mới phải là 6 chữ số')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu không khớp')),
      );
      return;
    }

    bool success = await AppDatabase.instance.updatePassword(widget.account, newPassword);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật mật khẩu thành công')),
      );
      Navigator.popUntil(context, (route) => route.isFirst); // Quay trở lại trang Login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra')),
      );
    }
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
              const SizedBox(height: AppSpacing.xl),
              Image.asset(
                'assests/images/logo.png',
                height: 60,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Đặt lại mật khẩu mới',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Nhập mật khẩu để đăng nhập tài khoản',
                style: AppTextStyles.bodyLight,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Care4uTextField(
                controller: _newPasswordController,
                hintText: 'Nhập mật khẩu mới (bao gồm 6 kí tự số)',
                isPassword: true,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.lg),
              Care4uTextField(
                controller: _confirmPasswordController,
                hintText: 'Nhập lại mật khẩu',
                isPassword: true,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.xl),
              Care4uButton(
                text: 'Xác nhận',
                onPressed: _handleResetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}