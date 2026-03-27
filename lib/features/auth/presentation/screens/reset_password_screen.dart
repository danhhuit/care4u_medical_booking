import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

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
              Image.asset(
                'assets/images/logo.png',
                height: 60,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Đặt lại mật khẩu mới',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Nhập mật khẩu để đăng nhập tài khoản',
                style: AppTextStyles.bodyLight,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              const Care4uTextField(
                hintText: 'Nhập mật khẩu mới (bao gồm 6 kí tự số)',
                isPassword: true,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Care4uTextField(
                hintText: 'Nhập lại mật khẩu',
                isPassword: true,
                suffixIcon: Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.textLight,
                  size: 20,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Care4uButton(
                text: 'Xác nhận',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}