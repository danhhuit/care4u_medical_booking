import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'revisit_schedule_page.dart';

class PrescriptionDetailPage extends StatelessWidget {
  const PrescriptionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: SettingsManager.themeMode,
          builder: (context, mode, _) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final cardColor = isDark ? const Color(0xFF1E2022) : Colors.white;
            final textColor = isDark ? Colors.white : Colors.black;
            final subTextColor = isDark ? Colors.white70 : Colors.black87;

            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                elevation: 0.5,
                centerTitle: true,
                title: Text(
                  AppTranslations.tr('prescription_detail') ?? 'Chi tiết đơn thuốc',
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppTranslations.tr('prescribed_meds')} (3 loại)',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const SizedBox(height: 15),
                    _buildMedicineItem(
                      context,
                      name: 'Paracetamol 500mg',
                      dose: '1 viên',
                      frequency: '2 ${AppTranslations.tr('dose_per_day')}',
                      time: '${AppTranslations.tr('morning')}, ${AppTranslations.tr('evening')} (${AppTranslations.tr('after_meal')})',
                      isDark: isDark,
                      cardColor: cardColor,
                      textColor: textColor,
                    ),
                    _buildMedicineItem(
                      context,
                      name: 'Esomeprazol 40mg',
                      dose: '1 viên',
                      frequency: '1 ${AppTranslations.tr('dose_per_day')}',
                      time: '${AppTranslations.tr('morning')} (${AppTranslations.tr('before_meal')})',
                      isDark: isDark,
                      cardColor: cardColor,
                      textColor: textColor,
                    ),
                    _buildMedicineItem(
                      context,
                      name: 'Phosphalugel',
                      dose: '1 gói',
                      frequency: '3 ${AppTranslations.tr('dose_per_day')}',
                      time: 'Khi đau (${AppTranslations.tr('after_meal')})',
                      isDark: isDark,
                      cardColor: cardColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 20),
                    
                    // Info Row: Prescribing Doctor
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_pin, color: Colors.blue),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppTranslations.tr('doctor_prescribed'), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              Text('BS. Lê Văn B', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Medical Note
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                AppTranslations.tr('medical_note'),
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tránh ăn đồ cay nóng, không uống rượu bia trong quá trình điều trị.',
                            style: TextStyle(fontSize: 13, color: subTextColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RevisitSchedulePage()),
                          );
                        },
                        icon: const Icon(Icons.calendar_month),
                        label: Text(
                          AppTranslations.tr('revisit_schedule'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildMedicineItem(
    BuildContext context, {
    required String name,
    required String dose,
    required String frequency,
    required String time,
    required bool isDark,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.vaccines, color: Colors.blue, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
                const SizedBox(height: 4),
                Text(
                  '${AppTranslations.tr('med_dose')}: $dose · $frequency',
                  style: const TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${AppTranslations.tr('med_usage')}: $time',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
