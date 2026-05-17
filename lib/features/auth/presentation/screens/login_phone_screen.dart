import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/register_screen.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/login_doctor_screen.dart';

import 'package:care4u_medical_booking/core/services/firebase_auth_service.dart';
import 'package:care4u_medical_booking/core/services/firestore_service.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/update_profile_screen.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({Key? key}) : super(key: key);

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    final account = _accountController.text.trim();
    final password = _passwordController.text.trim();

    if (account.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đủ thông tin')),
      );
      return;
    }

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
      if (!isEmail) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Định dạng tài khoản không hợp lệ')),
        );
        return;
      }
    }

    if (!RegExp(r'^\d{6}$').hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu không hợp lệ')),
      );
      return;
    }

    final user = await FirebaseAuthService.instance.loginUser(account, password);
    if (user != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công')),
      );
      
      final userProfile = await FirestoreService.instance.getUserProfile(account);
      if (!mounted) return;

      if (userProfile != null) {
        bool isFirstLogin = userProfile['isFirstLogin'] ?? true;
        String? name = userProfile['name'];

        if (isFirstLogin) {
          await FirestoreService.instance.markFirstLoginDone(account);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Text('Chào mừng!'),
                content: const Text('Đây là lần đầu bạn đăng nhập. Bạn có muốn cập nhật thông tin cá nhân ngay bây giờ không?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext); // Đóng dialog
                      Navigator.pushReplacementNamed(context, RouteNames.home); // Bỏ qua
                    },
                    child: const Text('Bỏ qua', style: TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext); // Đóng dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateProfileScreen(account: account)),
                      );
                    },
                    child: const Text('Cập nhật thông tin', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              );
            },
          );
        } else if (name == null || name.isEmpty) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Text('Thông báo'),
                content: const Text('Bạn chưa cập nhật thông tin người dùng, hãy cập nhật sớm nhất có thể.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pushReplacementNamed(context, RouteNames.home);
                    },
                    child: const Text('Bỏ qua', style: TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateProfileScreen(account: account)),
                      );
                    },
                    child: const Text('Cập nhật thông tin người dùng', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              );
            },
          );
        } else {
          Navigator.pushReplacementNamed(context, RouteNames.home);
        }
      } else {
        Navigator.pushReplacementNamed(context, RouteNames.home);
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sai tài khoản hoặc mật khẩu')),
      );
    }
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.huge),
              Image.asset('assests/images/logo.png', height: 120),
              const SizedBox(height: AppSpacing.huge),
              Care4uTextField(
                controller: _accountController,
                hintText: 'Nhập email hoặc số điện thoại',
              ),
              const SizedBox(height: AppSpacing.lg),
              Care4uTextField(
                controller: _passwordController,
                hintText: 'Mật khẩu',
                isPassword: true,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Quên mật khẩu?',
                    style: AppTextStyles.captionDark,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Care4uButton(
                text: 'Đăng nhập',
                onPressed: _handleLogin,
              ),
              const SizedBox(height: AppSpacing.lg),
              Care4uButton(
                text: 'Đăng nhập với tư cách Bác sĩ',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginDoctorScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              RichText(
                text: TextSpan(
                  text: 'Bạn chưa có tài khoản? ',
                  style: AppTextStyles.captionLight,
                  children: [
                    TextSpan(
                      text: 'Đăng kí ngay',
                      style: AppTextStyles.captionDark,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
