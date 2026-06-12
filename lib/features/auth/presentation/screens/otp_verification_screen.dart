import 'dart:async';

import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String account;
  final String? devOtp;

  const OtpVerificationScreen({super.key, required this.account, this.devOtp});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = false;
  bool _isResending = false;
  int _secondsLeft = 30;
  Timer? _timer;
  String? _latestDevOtp;

  @override
  void initState() {
    super.initState();
    _latestDevOtp = widget.devOtp;
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();

    setState(() {
      _secondsLeft = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
        });
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_isLoading) return;

    final otp = _otpController.text.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP phải gồm 6 chữ số')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _api.verifyForgotPasswordOtp(
        account: widget.account,
        otp: otp,
      );

      final resetToken = '${result['resetToken'] ?? ''}'.trim();

      if (resetToken.isEmpty) {
        throw Exception('Không nhận được reset token');
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(resetToken: resetToken),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final message = e.toString().contains('OTP hết hiệu lực')
          ? 'OTP hết hiệu lực'
          : 'Xác thực OTP thất bại: $e';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      if (message == 'OTP hết hiệu lực') {
        setState(() {
          _secondsLeft = 0;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_isResending || _secondsLeft > 0) return;

    setState(() => _isResending = true);

    try {
      final result = await _api.sendForgotPasswordOtp(account: widget.account);

      _latestDevOtp = '${result['devOtp'] ?? ''}'.trim();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _latestDevOtp != null && _latestDevOtp!.isNotEmpty
                ? 'Mã OTP mới demo: $_latestDevOtp'
                : 'Đã gửi lại mã OTP',
          ),
          duration: const Duration(seconds: 4),
        ),
      );

      _otpController.clear();
      _startCountdown();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gửi lại OTP thất bại: $e')));
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _secondsLeft == 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Xác thực OTP'),
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
              Text(
                'Nhập mã OTP 6 số đã gửi đến:\n${widget.account}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
              ),
              if (_latestDevOtp != null && _latestDevOtp!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  'OTP: $_latestDevOtp',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Care4uTextField(
                controller: _otpController,
                hintText: 'Nhập OTP',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                canResend
                    ? 'OTP đã hết hiệu lực. Vui lòng gửi lại mã.'
                    : 'OTP hết hiệu lực sau $_secondsLeft giây',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: canResend ? Colors.red : AppColors.textLight,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Care4uButton(
                text: _isLoading ? 'Đang xác thực...' : 'Xác thực OTP',
                onPressed: _verifyOtp,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: canResend && !_isResending ? _resendOtp : null,
                child: Text(
                  _isResending
                      ? 'Đang gửi lại...'
                      : canResend
                      ? 'Gửi lại mã'
                      : 'Gửi lại mã sau $_secondsLeft giây',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
