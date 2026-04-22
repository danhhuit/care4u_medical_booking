import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

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
            final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7F9);
            final cardColor = isDark ? const Color(0xFF1E2022) : Colors.white;
            final textColor = isDark ? Colors.white : const Color(0xFF2D2D2D);
            final subColor = isDark ? Colors.white60 : Colors.black54;

            final sections = [
              {'icon': Icons.login, 'section': 'user_guide_section1', 'content': 'user_guide_content1', 'color': const Color(0xFF3CA796)},
              {'icon': Icons.calendar_month, 'section': 'user_guide_section2', 'content': 'user_guide_content2', 'color': const Color(0xFF5B8FF9)},
              {'icon': Icons.event_note, 'section': 'user_guide_section3', 'content': 'user_guide_content3', 'color': const Color(0xFF73D13D)},
              {'icon': Icons.account_balance_wallet, 'section': 'user_guide_section4', 'content': 'user_guide_content4', 'color': const Color(0xFFFFA940)},
              {'icon': Icons.notifications, 'section': 'user_guide_section5', 'content': 'user_guide_content5', 'color': const Color(0xFFFF6B72)},
              {'icon': Icons.gavel, 'section': 'user_guide_section6', 'content': 'user_guide_content6', 'color': const Color(0xFF9254DE)},
            ];

            return Scaffold(
              backgroundColor: bgColor,
              appBar: AppBar(
                title: Text(AppTranslations.tr('user_guide_title')),
                centerTitle: true,
              ),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3CA796), Color(0xFF2BB5A0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_hospital, color: Colors.white, size: 40),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Care4U',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                AppTranslations.tr('user_guide_title'),
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sections
                  ...sections.map((s) => _buildSection(
                        context,
                        icon: s['icon'] as IconData,
                        title: AppTranslations.tr(s['section'] as String),
                        content: AppTranslations.tr(s['content'] as String),
                        color: s['color'] as Color,
                        cardColor: cardColor,
                        textColor: textColor,
                        subColor: subColor,
                        isDark: isDark,
                      )),

                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      '© 2026 Care4U. All rights reserved.',
                      style: TextStyle(color: subColor, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required Color subColor,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: textColor),
          ),
          iconColor: color,
          collapsedIconColor: subColor,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                content,
                style: TextStyle(
                    fontSize: 13.5,
                    height: 1.6,
                    color: subColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
