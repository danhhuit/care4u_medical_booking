import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
                'Chào mừng đến với Care4U',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Vui lòng nhập số điện thoại của bạn\nđể đăng kí tài khoản',
                style: AppTextStyles.bodyLight,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
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
                hintText: 'Nhập mật khẩu đăng nhập (6 kí tự số)',
                isPassword: true,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Care4uTextField(
                hintText: 'Nhập lại mật khẩu',
                isPassword: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Care4uButton(
                text: 'Đăng kí',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}