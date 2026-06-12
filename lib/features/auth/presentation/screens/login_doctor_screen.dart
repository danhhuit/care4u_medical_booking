import 'package:care4u_medical_booking/core/services/care4u_fcm_service.dart';
import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctor_main_screen.dart';

class LoginDoctorScreen extends StatefulWidget {
  const LoginDoctorScreen({super.key});

  @override
  State<LoginDoctorScreen> createState() => _LoginDoctorScreenState();
}

class _LoginDoctorScreenState extends State<LoginDoctorScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = false;
  bool _showPassword = false;

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

  String _normalizeLicense(String value) {
    return value.trim().replaceAll(' ', '').toUpperCase();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    final account = _normalizeAccount(_accountController.text);
    final licenseNumber = _normalizeLicense(_licenseController.text);
    final password = _passwordController.text.trim();

    if (account.isEmpty || licenseNumber.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    if (!account.contains('@') && !RegExp(r'^\d{10}$').hasMatch(account)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email hoặc số điện thoại không hợp lệ')),
      );
      return;
    }

    if (!RegExp(r'^LIC-\d{6}$').hasMatch(licenseNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mã định danh phải có dạng LIC-001234')),
      );
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu phải gồm 6 chữ số')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _api.loginWithDatabase(
        account: account,
        licenseNumber: licenseNumber,
        password: password,
      );

      final role = '${result['role'] ?? ''}'.trim();
      final doctorId = int.tryParse('${result['doctorId'] ?? ''}');

      if (role != 'doctor' || doctorId == null) {
        throw Exception('Tài khoản này không phải tài khoản bác sĩ');
      }

      await SettingsManager.setDoctorSession(
        doctorIdValue: doctorId,
        account: account,
        email: '${result['email'] ?? ''}'.trim(),
        phone: '${result['phone'] ?? ''}'.trim(),
        userId: '${result['userId'] ?? ''}'.trim(),
        licenseNumber: '${result['licenseNumber'] ?? licenseNumber}'.trim(),
      );

      final userId = '${result['userId'] ?? ''}'.trim();

      if (userId.isNotEmpty) {
        await Care4UFcmService.instance.registerTokenToApi(userId: userId);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập bác sĩ thành công')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DoctorMainScreen()),
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
    _licenseController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              Center(
                child: Image.asset('assests/images/logo.png', height: 120),
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
                controller: _accountController,
                hintText: 'Nhập email hoặc số điện thoại',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: AppSpacing.lg),

              Care4uTextField(
                controller: _licenseController,
                hintText: 'Nhập mã định danh nghề nghiệp',
              ),

              const SizedBox(height: AppSpacing.lg),

              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Mật khẩu',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
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
                onPressed: () {
                  if (_isLoading) return;
                  _handleLogin();
                },
              ),

              const SizedBox(height: AppSpacing.md),

              const Text(
                'Tài khoản mẫu: doctor.nguyen@care4u.vn / LIC-001234 / 123456',
                style: TextStyle(color: AppColors.textLight, fontSize: 12),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
