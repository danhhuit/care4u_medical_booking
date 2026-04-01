import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctor_main_screen.dart';

class LoginDoctorScreen extends StatelessWidget {
  const LoginDoctorScreen({Key? key}) : super(key: key);

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
                hintText: 'Nhập số điện thoại của bạn',
                prefix: Padding(
                  padding: const EdgeInsets.only(
                      left: AppSpacing.lg, right: AppSpacing.md),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('+84', style: AppTextStyles.bodyDark),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Care4uTextField(
                hintText: 'Nhập mã số định danh nghề nghiệp',
              ),
              const SizedBox(height: AppSpacing.lg),
              const Care4uTextField(
                hintText: 'Mật khẩu',
                isPassword: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ResetPasswordScreen()),
                  ),
                  child: const Text(
                    'Quên mật khẩu?',
                    style: AppTextStyles.captionDark,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Care4uButton(
                text: 'Đăng nhập',
                onPressed: () {
                  // Navigate to Doctor Dashboard
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DoctorMainScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}