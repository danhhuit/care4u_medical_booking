import 'dart:math';
import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/services/firebase_auth_service.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _accountController = TextEditingController();

  void _handleContinue() async {
    final account = _accountController.text.trim();

    if (account.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email hoặc số điện thoại')),
      );
      return;
    }

    // Check if account exists
    bool exists = await FirebaseAuthService.instance.checkAccountExists(account);

    if (!mounted) return;


    if (!exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tài khoản không tồn tại trên hệ thống')),
      );
      return;
    }

    bool isEmail = account.contains('@');
    if (isEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tính năng cấp lại mật khẩu hiện chỉ hỗ trợ qua Số điện thoại')),
      );
      return;
    }

    // Hiển thị vòng xoay tải
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Gọi API gửi SMS
    await FirebaseAuthService.instance.verifyPhoneNumber(
      phone: account,
      codeSent: (String verificationId, int? resendToken) {
        // Tắt vòng xoay tải
        Navigator.pop(context);
        
        // Chuyển sang màn hình xác thực OTP và truyền verificationId sang
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              account: account,
              verificationId: verificationId, // Sửa expectedOtp thành verificationId
            ),
          ),
        );
      },
      verificationFailed: (e) {
        Navigator.pop(context); // Tắt loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi gửi SMS: ${e.message}')),
        );
      },
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxxl),
              const Text(
                'Nhập số điện thoại hoặc email đã đăng ký để nhận mã xác thực (OTP).',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Care4uTextField(
                controller: _accountController,
                hintText: 'Nhập email hoặc số điện thoại',
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Care4uButton(
                text: 'Nhận mã OTP',
                onPressed: _handleContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
