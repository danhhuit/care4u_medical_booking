import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'medical_result_detail_page.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

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
            final subTextColor = isDark ? Colors.white70 : Colors.black54;

            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                elevation: 0.5,
                centerTitle: true,
                title: Text(
                  AppTranslations.tr('exam_results_title'),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. Kết quả chẩn đoán chính
                  _buildMedicalResultCard(
                    context,
                    title: AppTranslations.tr('diagnosis_confirmed'),
                    subtitle: 'Viêm dạ dày cấp tính',
                    date: '15/03/2026',
                    category: 'Nội khoa',
                    icon: Icons.assignment_turned_in,
                    color: Colors.blue,
                    cardColor: cardColor,
                    textColor: textColor,
                    subTextColor: subTextColor,
                  ),
                  
                  // 2. Kết quả cận lâm sàng (Xét nghiệm/Siêu âm)
                  _buildMedicalResultCard(
                    context,
                    title: AppTranslations.tr('abdominal_ultrasound'),
                    subtitle: 'Phát hiện vùng xung huyết nhẹ',
                    date: '15/03/2026',
                    category: 'Cận lâm sàng',
                    icon: Icons.image_search,
                    color: Colors.teal,
                    cardColor: cardColor,
                    textColor: textColor,
                    subTextColor: subTextColor,
                  ),

                  // 3. Đơn thuốc đi kèm
                  _buildMedicalResultCard(
                    context,
                    title: '${AppTranslations.tr('prescription_number')} #789',
                    subtitle: '4 loại thuốc - Dùng trong 7 ngày',
                    date: '15/03/2026',
                    category: 'Toa thuốc',
                    icon: Icons.medication,
                    color: Colors.orange,
                    cardColor: cardColor,
                    textColor: textColor,
                    subTextColor: subTextColor,
                  ),

                  // 4. Lời dặn từ bác sĩ
                  _buildMedicalResultCard(
                    context,
                    title: AppTranslations.tr('revisit_advice'),
                    subtitle: 'Kiêng đồ cay nóng, tái khám sau 1 tuần',
                    date: '15/03/2026',
                    category: 'Hướng dẫn',
                    icon: Icons.comment_bank,
                    color: Colors.purple,
                    cardColor: cardColor,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    isLast: true,
                  ),
                  
                  const SizedBox(height: 20),
                  // Banner thông tin bổ sung
                  _buildNoticeBanner(context),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMedicalResultCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String date,
    required String category,
    required IconData icon,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    bool isLast = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MedicalResultDetailPage(
              title: title,
              subtitle: subtitle,
              date: date,
              category: category,
              icon: icon,
              color: color,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                    Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 15),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: subTextColor, fontSize: 14)),
            const SizedBox(height: 10),
            if (!isLast)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppTranslations.tr('details_arrow'),
                style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.1))
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppTranslations.tr('hospital_system_update'),
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.blue[200] : Colors.blueGrey,
                height: 1.4,
              ),
            ),
          )
        ],
      ),
    );
  }
}