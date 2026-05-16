import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_spacing.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/core/widgets/care4u_button.dart';
import 'package:care4u_medical_booking/core/database/app_database.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String account;
  
  const UpdateProfileScreen({Key? key, required this.account}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  bool _isMale = true;

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

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
              const Text(
                'Cập nhật thông tin',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Để có thể tương tác tốt nhất với bác sĩ\nvui lòng cập nhật thông tin',
                style: AppTextStyles.bodyLight,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Họ tên',
                          style: AppTextStyles.captionLight,
                        ),
                        TextField(
                          controller: _nameController,
                          style: AppTextStyles.bodyDark,
                          decoration: const InputDecoration(
                            hintText: 'Nhập họ và tên',
                            hintStyle: AppTextStyles.bodyLight,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.borderLight),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ngày sinh',
                          style: AppTextStyles.captionLight,
                        ),
                        TextField(
                          controller: _dobController,
                          style: AppTextStyles.bodyDark,
                          decoration: const InputDecoration(
                            hintText: 'DD/MM/YYYY',
                            hintStyle: AppTextStyles.bodyLight,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.borderLight),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                children: [
                  const Text(
                    'Giới tính',
                    style: AppTextStyles.bodyLight,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isMale = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: _isMale ? AppColors.primary : const Color(0xFFCFD8DC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Nam',
                        style: TextStyle(
                          color: _isMale ? Colors.white : AppColors.textDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isMale = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: !_isMale ? AppColors.primary : const Color(0xFFCFD8DC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Nữ',
                        style: TextStyle(
                          color: !_isMale ? Colors.white : AppColors.textDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Care4uButton(
                text: 'Cập nhật',
                onPressed: () async {
                  final name = _nameController.text.trim();
                  final dob = _dobController.text.trim();
                  
                  if (name.isEmpty || dob.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng nhập đầy đủ họ tên và ngày sinh')),
                    );
                    return;
                  }
                  
                  bool success = await AppDatabase.instance.updateUserProfile(
                    widget.account, 
                    name, 
                    dob, 
                    _isMale
                  );
                  
                  if (success) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cập nhật thông tin thành công')),
                    );
                    Navigator.pushReplacementNamed(context, RouteNames.home);
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Có lỗi xảy ra, vui lòng thử lại')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
