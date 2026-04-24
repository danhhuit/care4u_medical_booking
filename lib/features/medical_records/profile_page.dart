import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: SettingsManager.themeMode,
          builder: (context, mode, _) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final patient = MockData.currentPatient;

            // Format date from YYYY-MM-DD to DD/MM/YYYY
            String formatDate(String iso) {
              if (iso.length < 10) return iso;
              final parts = iso.split('-');
              if (parts.length == 3) {
                return '${parts[2]}/${parts[1]}/${parts[0]}';
              }
              return iso;
            }

            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  AppTranslations.tr('personal_profile'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Header: Ảnh đại diện và tên
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        patient['name']!.split(' ').last.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      patient['name'] ?? 'Bệnh nhân',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'ID: BN-${patient['phone']?.substring(patient['phone'].length > 4 ? patient['phone'].length - 4 : 0) ?? "0000"}',
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    // Khối thông tin sinh hiệu
                    _buildInfoCard(context, [
                      _buildRowInfo(
                        context,
                        Icons.cake,
                        AppTranslations.tr('dob_label'),
                        formatDate(patient['dob'] ?? ''),
                      ),
                      _buildRowInfo(
                        context,
                        Icons.wc,
                        AppTranslations.tr('gender_label'),
                        patient['gender'] ?? 'Khác',
                      ),
                      _buildRowInfo(
                        context,
                        Icons.bloodtype,
                        AppTranslations.tr('blood_group_label'),
                        patient['bloodType'] ?? 'O+',
                        isLast: true,
                      ),
                    ]),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppTranslations.tr('health_indicators') ??
                              'Chỉ số sức khỏe',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),

                    _buildInfoCard(context, [
                      _buildRowInfo(
                        context,
                        Icons.monitor_weight,
                        AppTranslations.tr('weight_label') ?? 'Cân nặng',
                        patient['weight'] ?? '70 kg',
                      ),
                      _buildRowInfo(
                        context,
                        Icons.height,
                        AppTranslations.tr('height_label') ?? 'Chiều cao',
                        patient['height'] ?? '175 cm',
                      ),
                      _buildRowInfo(
                        context,
                        Icons.warning_amber,
                        AppTranslations.tr('allergies_label') ?? 'Dị ứng',
                        patient['allergies'] ?? 'Không',
                        isLast: true,
                      ),
                    ]),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2022) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRowInfo(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool isLast = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue, size: 22),
              const SizedBox(width: 15),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 50, color: Colors.grey),
      ],
    );
  }
}
