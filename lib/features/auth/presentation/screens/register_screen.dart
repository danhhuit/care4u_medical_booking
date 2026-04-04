import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_text_field.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      Image.asset('assests/images/logo.png', height: 60),
                      const SizedBox(height: AppSpacing.lg),
                      Text(AppTranslations.tr('register_title'),
                          style: AppTextStyles.heading2.copyWith(color: textColor)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppTranslations.tr('register_subtitle'),
                        style: AppTextStyles.bodyLight.copyWith(color: isDark ? Colors.white70 : AppColors.textLight),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      Care4uTextField(
                        hintText: AppTranslations.tr('register_email_hint'),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Care4uTextField(
                        hintText: AppTranslations.tr('register_pwd_hint'),
                        isPassword: true,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Care4uTextField(
                        hintText: AppTranslations.tr('register_confirm_pwd_hint'),
                        isPassword: true,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Care4uButton(
                        text: AppTranslations.tr('register_btn'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(AppTranslations.tr('register_success_title')),
                              content: Text(AppTranslations.tr('register_success_msg')),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacementNamed(
                                        context, RouteNames.login);
                                  },
                                  child: Text(
                                    AppTranslations.tr('login_now'),
                                    style: const TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
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