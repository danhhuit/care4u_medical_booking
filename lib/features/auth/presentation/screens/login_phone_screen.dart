import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/register_screen.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/login_doctor_screen.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class LoginPhoneScreen extends StatelessWidget {
  const LoginPhoneScreen({Key? key}) : super(key: key);

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
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.huge),
                      Image.asset('assests/images/logo_transparent.png', height: 120),
                      const SizedBox(height: AppSpacing.huge),
                      Care4uTextField(hintText: AppTranslations.tr('login_email_hint')),
                      const SizedBox(height: AppSpacing.lg),
                      Care4uTextField(hintText: AppTranslations.tr('login_password_hint'), isPassword: true),
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResetPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            AppTranslations.tr('forgot_password'),
                            style: AppTextStyles.captionDark.copyWith(color: isDark ? Colors.white : AppColors.textDark),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Care4uButton(
                        text: AppTranslations.tr('login_button'),
                        onPressed: () async {
                          await SettingsManager.setLoggedIn(true);
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Care4uButton(
                        text: AppTranslations.tr('login_as_doctor'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginDoctorScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      RichText(
                        text: TextSpan(
                          text: AppTranslations.tr('no_account'),
                          style: AppTextStyles.captionLight.copyWith(color: isDark ? Colors.white70 : AppColors.textLight),
                          children: [
                            TextSpan(
                              text: AppTranslations.tr('register_now'),
                              style: AppTextStyles.captionDark.copyWith(color: isDark ? Colors.white : AppColors.textDark),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterScreen(),
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
          },
        );
      },
    );
  }
}
