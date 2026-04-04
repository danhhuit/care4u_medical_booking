import 'package:flutter/material.dart';
import '../appointments/screens/book_appointment_screen.dart';
import 'profile_page.dart';
import 'results_page.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: SettingsManager.themeMode,
          builder: (context, mode, _) {
            return Scaffold(
              backgroundColor: const Color(0xFFF5F7F9), 
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.5,
                centerTitle: true,
                title: Text(
                  AppTranslations.tr('medical_history_title'),
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.assignment_turned_in_outlined, color: Colors.blue),
                    tooltip: AppTranslations.tr('exam_results'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ResultsPage()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline, color: Colors.blue),
                    tooltip: AppTranslations.tr('personal_profile'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Section 1: Nearest Appointment ---
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                      child: Text(
                        AppTranslations.tr('nearest_appointment'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Column(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 60, color: Colors.redAccent),
                                const SizedBox(height: 10),
                                Text(
                                  AppTranslations.tr('no_appointment_yet'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BookAppointmentScreen(
                                    doctorData: {},
                                  ),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text(
                              AppTranslations.tr('book_new_exam'),
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- Section 2: History list ---
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 25, 16, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppTranslations.tr('exam_history'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(AppTranslations.tr('see_all'), style: const TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ),
                    
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            const Icon(Icons.description_outlined, size: 80, color: Colors.blueGrey),
                            const SizedBox(height: 15),
                            Text(
                              AppTranslations.tr('no_exam_history'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                AppTranslations.tr('exam_history_desc'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- Section 3: Bottom actions ---
                    const SizedBox(height: 10),           
                    _buildActionTile(AppTranslations.tr('want_buy_medicine'), AppTranslations.tr('order_now')),
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

  Widget _buildActionTile(String title, String actionText) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            actionText,
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}