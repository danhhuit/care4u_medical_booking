import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';

class Care4uTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final Widget? prefix;
  final Widget? suffixIcon;

  const Care4uTextField({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    this.prefix,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textLight,
        ),
        prefixIcon: prefix,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}