import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class DoctorPatientsScreen extends StatefulWidget {
  const DoctorPatientsScreen({super.key});
  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  final _searchCtrl = TextEditingController();
  late List<Map<String, dynamic>> _filtered;

  // Build a patient list from appointments
  final List<Map<String, dynamic>> _patients = [
    {
      'id': 'p1', 'name': 'Nguyễn Văn Hùng', 'age': 35, 'gender': 'Nam',
      'lastVisit': '2026-03-28', 'diagnosis': 'Hở van tim',
    },
    {
      'id': 'p2', 'name': 'Lê Thị Mai', 'age': 28, 'gender': 'Nữ',
      'lastVisit': '2026-03-20', 'diagnosis': 'Tăng huyết áp',
    },
    {
      'id': 'p3', 'name': 'Trần Minh Khoa', 'age': 45, 'gender': 'Nam',
      'lastVisit': '2026-02-15', 'diagnosis': 'Nhồi máu cơ tim nhẹ',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filtered = List.from(_patients);
    _searchCtrl.addListener(_filter);
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _patients.where((p) =>
          p['name'].toString().toLowerCase().contains(q)).toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _genderText(String raw) {
    if (raw == 'Nam') return AppTranslations.tr('male');
    if (raw == 'Nữ') return AppTranslations.tr('female');
    return AppTranslations.tr('other_gender');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = SettingsManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final appBarColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(AppTranslations.tr('my_patients'), style: TextStyle(color: textColor)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: AppTranslations.tr('search_patients_hint'),
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      AppTranslations.tr('no_patients_found'),
                      style: TextStyle(color: subTextColor),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final p = _filtered[i];
                      final displayGender = _genderText('${p['gender']}');
                      final ageText = '${p['age']} ${SettingsManager.currentLanguage == 'vi' ? 'tuổi' : 'years old'}';

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              radius: 24,
                              child: Text(
                                p['name'].toString().split(' ').last.substring(0, 1),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p['name']!, style: AppTextStyles.bodyDark.copyWith(color: textColor)),
                                  Text(
                                    '$displayGender • $ageText',
                                    style: AppTextStyles.captionLight.copyWith(color: subTextColor),
                                  ),
                                  Text(
                                    '${AppTranslations.tr('diagnosis_label')}: ${p['diagnosis']}',
                                    style: TextStyle(
                                        fontSize: 12, color: subTextColor),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(AppTranslations.tr('last_visit_label'),
                                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                Text(p['lastVisit']!,
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
