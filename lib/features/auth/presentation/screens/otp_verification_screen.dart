import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:care4u_medical_booking/core/services/firebase_auth_service.dart';
import 'dart:async';
import 'dart:math';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String account;
  final String verificationId; // Đổi tên biến cho rõ nghĩa

  const OtpVerificationScreen({
    Key? key,
    required this.account,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  late String _currentVerificationId;
  bool _isExpired = false;
  Timer? _timer;
  int _countdown = 60;

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _isExpired = false;
      _countdown = 60;
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

  void _verifyOtp() async {
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
        const SnackBar(content: Text('Mã OTP đã hết hạn, vui lòng yêu cầu gửi lại')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _currentVerificationId,
        smsCode: enteredOtp,
      );

      // Xác thực mã OTP với Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (!mounted) return;
      Navigator.pop(context); // Đóng loading

      // OTP đúng, chuyển sang trang đổi mật khẩu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(account: widget.account),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Đóng loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mã OTP không chính xác hoặc đã hết hạn!')),
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
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    if (!_isExpired) return;
                    
                    // Vì dùng mã Test cố định của Firebase nên mã sẽ không thay đổi.
                    // Việc gọi lại API verifyPhoneNumber là không cần thiết (trừ khi session quá 15 phút).
                    // Ta chỉ cần reset lại giao diện và bộ đếm thời gian.
                    setState(() {
                      for (var c in _controllers) {
                        c.clear();
                      }
                      FocusScope.of(context).requestFocus(_focusNodes[0]);
                    });
                    _startTimer();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã yêu cầu lại. Vui lòng nhập Mã Test mà bạn đã thiết lập trên Firebase Console!')),
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