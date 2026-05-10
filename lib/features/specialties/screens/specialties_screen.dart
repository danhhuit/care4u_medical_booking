import 'package:flutter/material.dart';
import '../widgets/specialty_card.dart';
import 'specialty_doctors_screen.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class SpecialtiesScreen extends StatelessWidget {
  const SpecialtiesScreen({super.key});
  final List<Map<String, dynamic>> _specialties = const [
    {'title': 'Tim mạch', 'icon': Icons.favorite, 'color': Colors.red},
    {'title': 'Thần kinh', 'icon': Icons.psychology, 'color': Colors.purple},
    {'title': 'Nhi khoa', 'icon': Icons.child_care, 'color': Colors.orange},
    {'title': 'Da liễu', 'icon': Icons.face, 'color': Colors.pink},
    {'title': 'Nha khoa', 'icon': Icons.health_and_safety, 'color': Colors.teal},
    {'title': 'Mắt', 'icon': Icons.remove_red_eye, 'color': Colors.blue},
    {'title': 'Tai Mũi Họng', 'icon': Icons.hearing, 'color': Colors.green},
    {'title': 'Tiêu hóa', 'icon': Icons.restaurant, 'color': Colors.brown},
  ];

  String _getSpecialtyTranslationKey(String spec) {
    if (spec == 'Tim mạch') return 'cardiology';
    if (spec == 'Nhi khoa') return 'pediatrics';
    if (spec == 'Thần kinh') return 'neurology';
    if (spec == 'Da liễu') return 'dermatology';
    if (spec == 'Nha khoa') return 'dentistry';
    if (spec == 'Mắt') return 'ophthalmology';
    if (spec == 'Tai Mũi Họng') return 'ent';
    if (spec == 'Tiêu hóa') return 'gastroenterology';
    return spec;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppTranslations.tr('specialties')),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslations.tr('specialty_search_title'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: _specialties.length,
                    itemBuilder: (context, index) {
                      final spec = _specialties[index];
                      return SpecialtyCard(
                        title: AppTranslations.tr(_getSpecialtyTranslationKey(spec['title'] as String)),
                        icon: spec['icon'] as IconData,
                        color: spec['color'] as Color,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpecialtyDoctorsScreen(
                                specialty: spec['title'] as String,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}