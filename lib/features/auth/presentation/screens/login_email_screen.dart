import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';

class LoginEmailScreen extends StatelessWidget {
  const LoginEmailScreen({Key? key}) : super(key: key);

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
                height: 120,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              const Text(
                'Tạo tài khoản',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSpacing.sm),
              RichText(
                text: TextSpan(
                  text: 'Bạn chưa có tài khoản? ',
                  style: AppTextStyles.captionLight,
                  children: [
                    TextSpan(
                      text: 'Đăng kí ngay',
                      style: AppTextStyles.captionDark,
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Care4uTextField(
                hintText: 'email@domain.com',
              ),
              const SizedBox(height: AppSpacing.lg),
              Care4uButton(
                text: 'Đăng nhập',
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: AppColors.divider,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Text(
                      'or',
                      style: AppTextStyles.captionLight,
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: AppColors.divider,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 20,
                    width: 20,
                  ),
                  label: const Text(
                    'Tiếp tục với Google',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.googleButtonBackground,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}