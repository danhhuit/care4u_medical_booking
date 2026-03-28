import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';

class LoginDoctorScreen extends StatelessWidget {
  const LoginDoctorScreen({Key? key}) : super(key: key);

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
              const SizedBox(height: AppSpacing.huge),
              Center(
                child: Image.asset(
                  'assests/images/logo.png',
                  height: 120,
                ),
              ),
              const SizedBox(height: AppSpacing.huge),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Quên mật khẩu?',
                  style: AppTextStyles.captionDark,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
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
              const Care4uTextField(
                hintText: 'Nhập mã số định danh nghề nghiệp',
              ),
              const SizedBox(height: AppSpacing.lg),
              const Care4uTextField(
                hintText: 'Mật khẩu',
                isPassword: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Care4uButton(
                text: 'Đăng nhập',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}