import 'package:flutter/material.dart';
import '../../appointments/screens/book_appointment_screen.dart';
import 'doctor_reviews_screen.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Map<String, dynamic> doctorData;
  const DoctorDetailScreen({super.key, required this.doctorData});
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
            final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
            final textColor = isDark ? Colors.white : Colors.black87;

            return Scaffold(
              backgroundColor: bgColor,
              appBar: AppBar(
                title: Text(AppTranslations.tr('doctor_detail')),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.blue,
                foregroundColor: Colors.white,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: doctorData['id'],
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(doctorData['imageUrl'] ?? 'assests/images/default_doctor.jpg'),
                            onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 50),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorData['name'],
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                doctorData['specialty'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorReviewsScreen(doctorData: doctorData),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${doctorData['rating']} (${doctorData['reviews']} ${AppTranslations.tr('reviews_count')})',
                                      style: TextStyle(fontSize: 14, decoration: TextDecoration.underline, color: textColor.withValues(alpha: 0.8)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppTranslations.tr('general_info'),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      doctorData['bio'] ?? AppTranslations.tr('no_bio'),
                      style: TextStyle(fontSize: 15, height: 1.5, color: textColor.withValues(alpha: 0.9)),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard(Icons.people, AppTranslations.tr('patients'), '1000+', isDark),
                        _buildInfoCard(Icons.work, AppTranslations.tr('experience'), '10 ${AppTranslations.tr('years')}', isDark),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorReviewsScreen(doctorData: doctorData),
                              ),
                            );
                          },
                          child: _buildInfoCard(Icons.star_rate, AppTranslations.tr('rating'), '${doctorData['rating']}', isDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppointmentScreen(doctorData: doctorData),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      AppTranslations.tr('book_with_doctor'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value, bool isDark) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }
}
