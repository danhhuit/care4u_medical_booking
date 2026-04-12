import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/login_phone_screen.dart';

import 'package:care4u_medical_booking/core/database/app_database.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';

class LoginDoctorScreen extends StatefulWidget {
  const LoginDoctorScreen({Key? key}) : super(key: key);

  @override
  State<LoginDoctorScreen> createState() => _LoginDoctorScreenState();
}

class _LoginDoctorScreenState extends State<LoginDoctorScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _doctorIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    final phone = _phoneController.text.trim();
    final doctorId = _doctorIdController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || doctorId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đủ thông tin')),
      );
      return;
    }

    bool isPhoneOnlyDigits = RegExp(r'^\d+$').hasMatch(phone);

    if (isPhoneOnlyDigits) {
      if (phone.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Số điện thoại không hợp lệ')),
        );
        return;
      }
    } else {
      // It specifies phone, so email isn't strictly expected, but just in case
      bool isEmail = phone.contains('@');
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

    bool success = await AppDatabase.instance.loginDoctor(phone, password, doctorId);
    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công')),
      );
      Navigator.pushReplacementNamed(context, RouteNames.home);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sai thông tin đăng nhập')),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _doctorIdController.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPhoneScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: Image.asset(
                  'assests/images/logo.png',
                  height: 120,
                ),
              ),
              const SizedBox(height: AppSpacing.huge),

              const Text(
                'Chào mừng bạn đã trở lại với trang thông tin\ndành cho Bác sĩ',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Care4uTextField(
                controller: _phoneController,
                hintText: 'Nhập số điện thoại của bạn',
                keyboardType: TextInputType.phone,
                prefix: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.md),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        '+84',
                        style: AppTextStyles.bodyDark,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Care4uTextField(
                controller: _doctorIdController,
                hintText: 'Nhập mã số định danh nghề nghiệp',
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
            ],
          ),
        ),
      ),
    );
  }
}