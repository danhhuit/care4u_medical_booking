import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/settings_screen.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  Map<String, dynamic> get _patient => MockData.currentPatient;

  void _goEdit() async {
    await Navigator.pushNamed(context, RouteNames.editPatientProfile);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: isDark ? Colors.black : AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark 
                      ? [const Color(0xFF121212), Colors.black]
                      : [const Color(0xFF2BB5A0), const Color(0xFF1A7A6E)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                        child: Text(
                          _patient['name']!.split(' ').last.substring(0, 1),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _patient['name']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _patient['email']!,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: _goEdit,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppTranslations.tr('personal_info_header'), style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                  _infoCard([
                    _infoRow(Icons.phone, AppTranslations.tr('phone_label'), _patient['phone']!),
                    _divider(),
                    _infoRow(Icons.cake, AppTranslations.tr('dob_label'), _formatDate(_patient['dob']!)),
                    _divider(),
                    _infoRow(Icons.person, AppTranslations.tr('gender_label'), _patient['gender']!),
                    _divider(),
                    _infoRow(Icons.location_on, AppTranslations.tr('address_label'), _patient['address']!),
                    _divider(),
                    _infoRow(Icons.water_drop, AppTranslations.tr('blood_group_label'), _patient['bloodType']!),
                  ]),
                  const SizedBox(height: 20),
                  Text(AppTranslations.tr('activity_header'), style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                  _actionCard(
                    context,
                    Icons.calendar_today,
                    AppTranslations.tr('my_appointments'),
                    AppTranslations.tr('manage_appointments'),
                    () => Navigator.pushNamed(context, RouteNames.appointmentList),
                  ),
                  const SizedBox(height: 8),
                  _actionCard(
                    context,
                    Icons.folder_open,
                    AppTranslations.tr('medical_records'),
                    AppTranslations.tr('medical_history_desc'),
                    () => Navigator.pushNamed(context, RouteNames.medicalRecordList),
                  ),
                  const SizedBox(height: 8),
                  _actionCard(
                    context,
                    Icons.medication,
                    AppTranslations.tr('prescriptions'),
                    AppTranslations.tr('prescriptions_desc'),
                    () => Navigator.pushNamed(context, RouteNames.medicalRecordList),
                  ),
                  const SizedBox(height: 8),
                  _actionCard(
                    context,
                    Icons.settings,
                    AppTranslations.tr('settings'),
                    AppTranslations.tr('settings_desc'),
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, RouteNames.login);
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: Text(AppTranslations.tr('logout'), style: const TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(List<Widget> children) => Card(
        margin: EdgeInsets.zero,
        child: Column(children: children),
      );

  Widget _infoRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(label, style: AppTextStyles.captionLight),
                  const SizedBox(height: 2),
                  Text(value, style: AppTextStyles.bodyDark),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _divider() => const Divider(height: 1, indent: 48);

  Widget _actionCard(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) => Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.bodyDark),
                      Text(subtitle, style: AppTextStyles.captionLight),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      );

  String _formatDate(String iso) {
    if (iso.length < 10) return iso;
    final parts = iso.split('-');
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}
