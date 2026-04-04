import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctor_main_screen.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class LoginDoctorScreen extends StatelessWidget {
  const LoginDoctorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: SettingsManager.themeMode,
          builder: (context, mode, _) {
            final isDark = mode == ThemeMode.dark ||
                (mode == ThemeMode.system &&
                    MediaQuery.of(context).platformBrightness == Brightness.dark);
            final bgColor = isDark ? const Color(0xFF1E1E1E) : AppColors.background;
            final textColor = isDark ? Colors.white : AppColors.textDark;

            return Scaffold(
              backgroundColor: bgColor,
              appBar: AppBar(
                backgroundColor: bgColor,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: textColor),
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
                      Text(
                        AppTranslations.tr('doctor_welcome'),
                        style: TextStyle(
                          color: isDark ? Colors.white70 : AppColors.textLight,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Care4uTextField(
                        hintText: AppTranslations.tr('doctor_phone_hint'),
                        prefix: Padding(
                          padding: const EdgeInsets.only(
                              left: AppSpacing.lg, right: AppSpacing.md),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('+84', style: AppTextStyles.bodyDark.copyWith(color: textColor)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Care4uTextField(
                        hintText: AppTranslations.tr('doctor_id_hint'),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Care4uTextField(
                        hintText: AppTranslations.tr('login_password_hint'),
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
                          child: Text(
                            AppTranslations.tr('forgot_password'),
                            style: AppTextStyles.captionDark.copyWith(color: isDark ? Colors.white : AppColors.textDark),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Care4uButton(
                        text: AppTranslations.tr('login_button'),
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
          },
        );
      },
    );
  }
}