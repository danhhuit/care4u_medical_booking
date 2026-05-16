import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle bodyDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static const TextStyle bodyLight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static const TextStyle captionDark = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle captionLight = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}