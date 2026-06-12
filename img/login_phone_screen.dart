import 'package:care4u_medical_booking/core/services/care4u_fcm_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:care4u_medical_booking/features/admin/presentation/screens/admin_users_screen.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/login_doctor_screen.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/register_screen.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = false;

  String _text(dynamic value) {
    if (value == null || '$value' == 'null') return '';
    return '$value'.trim();
  }

  bool _isGuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    final account = _accountController.text.trim();
    final password = _passwordController.text.trim();

    if (account.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tài khoản và mật khẩu')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _api.loginWithDatabase(
        account: account,
        password: password,
      );

      final role = _text(result['role']);
      final userId = _text(result['userId'] ?? result['user_id'] ?? result['id']);

      debugPrint('LOGIN RESULT: $result');
      debugPrint('LOGIN USER ID: $userId');

      if (role == 'admin') {
        await SettingsManager.setAdminSession(
          account: account,
          email: _text(result['email']),
          phone: _text(result['phone']),
          userId: _isGuid(userId) ? userId : null,
        );

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AdminUsersScreen()),
          (route) => false,
        );

        return;
      }

      final patientId = int.tryParse('${result['patientId'] ?? ''}');

      if (role != 'patient' || patientId == null) {
        throw Exception('Tài khoản này không phải tài khoản bệnh nhân');
      }

      if (!_isGuid(userId)) {
        throw Exception('API đăng nhập chưa trả userId hợp lệ');
      }

      await SettingsManager.setPatientSession(
        patientIdValue: patientId,
        account: account,
        email: _text(result['email']),
        phone: _text(result['phone']),
        fullName: _text(result['fullName'] ?? result['name'] ?? result['email']),
        userId: userId,
      );

      try {
        await Care4UFcmService.instance.registerTokenToApi(userId: userId);
        debugPrint('SAVE FCM TOKEN OK');
      } catch (e) {
        debugPrint('SAVE FCM TOKEN ERROR: $e');
      }

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.home,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đăng nhập thất bại: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                  onTap: _isLoading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
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
                text: _isLoading ? 'Đang đăng nhập...' : 'Đăng nhập',
                onPressed: _handleLogin,
              ),

              const SizedBox(height: AppSpacing.lg),

              Care4uButton(
                text: 'Đăng nhập với tư cách Bác sĩ',
                onPressed: _isLoading
                    ? () {}
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginDoctorScreen(),
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
                          if (_isLoading) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
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
