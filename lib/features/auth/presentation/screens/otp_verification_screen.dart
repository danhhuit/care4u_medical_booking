import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'dart:math';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String account;
  final String expectedOtp;

  const OtpVerificationScreen({
    Key? key,
    required this.account,
    required this.expectedOtp,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  late String _currentOtp;
  bool _isExpired = false;
  Timer? _timer;
  int _countdown = 30;

  @override
  void initState() {
    super.initState();
    _currentOtp = widget.expectedOtp;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _isExpired = false;
      _countdown = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _isExpired = true;
        });
        timer.cancel();
      }
    });
  }

  void _verifyOtp() {
    String enteredOtp = _controllers.map((c) => c.text).join();
    
    // Check if fully entered
    if (enteredOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đủ 6 chữ số')),
      );
      return;
    }

    if (_isExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mã OTP này đã hết hạn và không hợp lệ')),
      );
      return;
    }

    if (enteredOtp == _currentOtp) {
      // OTP matched, navigate to ResetPasswordScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(account: widget.account),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mã OTP không chính xác!')),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Xác thực OTP'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.huge),
              const Text(
                'Chúng tôi đã gửi mã đến số điện thoại/email sau:',
                style: AppTextStyles.bodyLight,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.account,
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 45,
                    height: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      cursorColor: AppColors.primary,
                      maxLength: 1,
                      style: AppTextStyles.heading2,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.borderLight, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Care4uButton(
                text: 'Xác nhận',
                onPressed: _verifyOtp,
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Bạn chưa nhận được mã?',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSpacing.sm),
              RichText(
                text: TextSpan(
                  text: _isExpired ? 'Gửi lại mã' : 'Vui lòng chờ $_countdown giây để gửi lại',
                  style: AppTextStyles.bodyLight.copyWith(
                    color: _isExpired ? AppColors.primary : Colors.grey,
                    fontWeight: _isExpired ? FontWeight.bold : FontWeight.normal,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    if (!_isExpired) return;
                    setState(() {
                      _currentOtp = (100000 + Random().nextInt(900000)).toString();
                      for (var c in _controllers) {
                        c.clear();
                      }
                      FocusScope.of(context).requestFocus(_focusNodes[0]);
                    });
                    _startTimer();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Mã OTP mới của bạn là: $_currentOtp'),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}