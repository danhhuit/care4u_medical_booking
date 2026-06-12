import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _accountController = TextEditingController();
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = false;

  String _normalizeAccount(String value) {
    var account = value.trim().replaceAll(' ', '').replaceAll('-', '');

    if (account.startsWith('+84')) {
      account = '0${account.substring(3)}';
    }

    if (account.startsWith('84') && account.length == 11) {
      account = '0${account.substring(2)}';
    }

    return account;
  }

  Future<void> _sendOtp() async {
    if (_isLoading) return;

    final account = _normalizeAccount(_accountController.text);

    if (account.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email hoặc số điện thoại')),
      );
      return;
    }

    if (!account.contains('@') && !RegExp(r'^\d{10}$').hasMatch(account)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email hoặc số điện thoại không hợp lệ')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _api.sendForgotPasswordOtp(account: account);

      final devOtp = '${result['devOtp'] ?? ''}'.trim();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            devOtp.isNotEmpty ? 'Mã OTP demo: $devOtp' : 'Mã OTP đã được gửi',
          ),
          duration: const Duration(seconds: 4),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              OtpVerificationScreen(account: account, devOtp: devOtp),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gửi OTP thất bại: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Nhập số điện thoại hoặc email đã đăng ký để nhận mã xác thực OTP.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Care4uTextField(
                controller: _accountController,
                hintText: 'Email hoặc số điện thoại',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.xl),
              Care4uButton(
                text: _isLoading ? 'Đang gửi...' : 'Nhận mã OTP',
                onPressed: _sendOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
