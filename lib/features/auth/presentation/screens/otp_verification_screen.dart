import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.huge),
              const Text(
                'Chúng tôi đã gửi mã đến số điện thoại sau:',
                style: AppTextStyles.bodyLight,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                '*******570',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: AppTextStyles.heading2,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Care4uButton(
                text: 'Xác nhận',
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Bạn chưa nhận được mã?',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSpacing.sm),
              RichText(
                text: TextSpan(
                  text: 'Gửi lại mã',
                  style: AppTextStyles.bodyLight,
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}