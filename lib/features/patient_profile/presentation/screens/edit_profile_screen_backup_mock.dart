import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _dobCtrl;
  String _selectedGenderKey = 'male';

  @override
  void initState() {
    super.initState();
    final p = MockData.currentPatient;
    _nameCtrl = TextEditingController(text: p['name']);
    _phoneCtrl = TextEditingController(text: p['phone']);
    _addressCtrl = TextEditingController(text: p['address']);
    _dobCtrl = TextEditingController(text: p['dob']);
    
    if (p['gender'] == 'Nam' || p['gender'] == 'Male') {
      _selectedGenderKey = 'male';
    } else if (p['gender'] == 'Nữ' || p['gender'] == 'Female') {
      _selectedGenderKey = 'female';
    } else {
      _selectedGenderKey = 'other_gender';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  void _save() {
    MockData.currentPatient = {
      ...MockData.currentPatient,
      'name': _nameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'address': _addressCtrl.text.trim(),
      'dob': _dobCtrl.text.trim(),
      'gender': AppTranslations.tr(_selectedGenderKey),
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppTranslations.tr('save_success')),
        backgroundColor: AppColors.primary,
      ),
    );
    Navigator.pop(context);
  }

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
                title: Text(AppTranslations.tr('edit_profile')),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: const Icon(Icons.person, size: 52, color: AppColors.primary),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary,
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                    const SizedBox(height: 28),
                    _label(AppTranslations.tr('name_label'), isDark),
                    _field(_nameCtrl, AppTranslations.tr('enter_name'), isDark),
                    const SizedBox(height: 16),
                    _label(AppTranslations.tr('phone_label'), isDark),
                    _field(_phoneCtrl, AppTranslations.tr('enter_phone'), isDark, type: TextInputType.phone),
                    const SizedBox(height: 16),
                    _label(AppTranslations.tr('dob_label_full'), isDark),
                    _field(_dobCtrl, AppTranslations.tr('enter_dob'), isDark),
                    const SizedBox(height: 16),
                    _label(AppTranslations.tr('gender_label'), isDark),
                    Row(
                      children: ['male', 'female', 'other_gender'].map((g) {
                        final selected = _selectedGenderKey == g;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(AppTranslations.tr(g)),
                            selected: selected,
                            selectedColor: AppColors.primary,
                            backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey[200],
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : (isDark ? Colors.white : AppColors.textDark),
                            ),
                            onSelected: (_) => setState(() => _selectedGenderKey = g),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _label(AppTranslations.tr('address_label'), isDark),
                    _field(_addressCtrl, AppTranslations.tr('enter_address'), isDark, maxLines: 2),
                    const SizedBox(height: 32),
                    SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppTranslations.tr('save_changes'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
          },
        );
      },
    );
  }
  Widget _label(String text, bool isDark) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: AppTextStyles.captionDark.copyWith(color: isDark ? Colors.white : AppColors.textDark)),
      );

  Widget _field(
    TextEditingController ctrl,
    String hint,
    bool isDark, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      maxLines: maxLines,
      style: TextStyle(
        color: isDark ? Colors.white : AppColors.textDark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.white54 : AppColors.textLight,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

