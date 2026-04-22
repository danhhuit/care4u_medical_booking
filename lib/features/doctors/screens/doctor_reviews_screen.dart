import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class DoctorReviewsScreen extends StatelessWidget {
  final Map<String, dynamic> doctorData;
  const DoctorReviewsScreen({super.key, required this.doctorData});

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

            final doctorId = doctorData['id']?.toString() ?? '';
            final filteredReviews = MockData.reviews
                .where((r) => r['doctorId'] == doctorId)
                .toList();

            final avgRating = filteredReviews.isEmpty
                ? (doctorData['rating'] ?? 0.0)
                : filteredReviews.map((r) => r['rating'] as int).reduce((a, b) => a + b) /
                    filteredReviews.length;

            final cardColor = isDark ? const Color(0xFF1E2022) : Colors.white;
            final subTextColor = isDark ? Colors.white54 : Colors.grey[600]!;

            return Scaffold(
              appBar: AppBar(
                title: Text(AppTranslations.tr('rate_doctor')),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  // ── Doctor summary ──
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF3CA796),
                          child: Text(
                            (doctorData['name'] as String? ?? 'D')
                                .split(' ')
                                .last
                                .substring(0, 1),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorData['name'] ?? '',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  ...List.generate(5, (i) => Icon(
                                    i < avgRating.round()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  )),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${avgRating.toStringAsFixed(1)} (${filteredReviews.length} ${AppTranslations.tr('reviews_count')})',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white70 : Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  // ── Review list ──
                  Expanded(
                    child: filteredReviews.isEmpty
                        ? Center(
                            child: Text(
                              AppTranslations.tr('no_reviews_yet'),
                              style: TextStyle(color: subTextColor),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredReviews.length,
                            separatorBuilder: (_, __) => const Divider(height: 24),
                            itemBuilder: (context, index) {
                              return _buildReviewCard(
                                  filteredReviews[index], isDark, cardColor, subTextColor);
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReviewCard(
    Map<String, dynamic> review,
    bool isDark,
    Color cardColor,
    Color subTextColor,
  ) {
    final rating = review['rating'] as int? ?? 0;
    final patientName = review['patientName'] as String? ?? '';
    final initial = patientName.isNotEmpty ? patientName[0] : '?';
    final dateTime = '${review['date'] ?? ''}'
        '${review['time'] != null ? ' · ${review['time']}' : ''}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF3CA796).withValues(alpha: 0.15),
                child: Text(
                  initial,
                  style: const TextStyle(
                      color: Color(0xFF3CA796), fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateTime,
                      style: TextStyle(color: subTextColor, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 15,
                )),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review['comment'] ?? '',
            style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black87),
          ),
        ],
      ),
    );
  }
}
