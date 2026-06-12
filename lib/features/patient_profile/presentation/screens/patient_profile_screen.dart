import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/settings_screen.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/features/chat/presentation/screens/patient_chat_rooms_screen.dart';
import 'package:care4u_medical_booking/features/reviews/presentation/screens/review_list_screen.dart';
import 'edit_profile_screen.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _patient;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _api.getPatientById(SettingsManager.currentPatientId);
      if (!mounted) return;

      setState(() {
        _patient = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Không thể tải hồ sơ bệnh nhân: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _goEdit() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(initialPatient: _patient),
      ),
    );

    if (updated == true) {
      await _loadPatient();
    }
  }

  String _value(String key, {String fallback = 'Chưa cập nhật'}) {
    final value = _patient?[key];
    if (value == null || value.toString().trim().isEmpty) return fallback;
    return value.toString();
  }

  String _patientName() => _value('fullName', fallback: 'Bệnh nhân');

  String _genderText() {
    final value = _value('gender', fallback: '').toUpperCase();
    if (value == 'M') return AppTranslations.tr('male');
    if (value == 'F') return AppTranslations.tr('female');
    if (value == 'O') return AppTranslations.tr('other_gender');
    return value.isEmpty ? 'Chưa cập nhật' : value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: SettingsManager.themeMode,
          builder: (context, mode, _) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final textColor = Theme.of(context).textTheme.bodyLarge?.color;
            final headingStyle = TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            );
            final bodyStyle = TextStyle(
              fontSize: 16,
              color: textColor,
              fontWeight: FontWeight.w500,
            );
            final captionStyle = const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            );

            if (_isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (_error != null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Hồ sơ cá nhân')),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadPatient,
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final name = _patientName();
            final email = _value('email', fallback: 'care4u@example.com');

            return Scaffold(
              body: RefreshIndicator(
                onRefresh: _loadPatient,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 200,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: isDark
                          ? Colors.black
                          : AppColors.primary,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [const Color(0xFF121212), Colors.black]
                                  : [
                                      const Color(0xFF2BB5A0),
                                      const Color(0xFF1A7A6E),
                                    ],
                            ),
                          ),
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 16),
                                CircleAvatar(
                                  radius: 44,
                                  backgroundColor: isDark
                                      ? Colors.grey[900]
                                      : Colors.white,
                                  child: Text(
                                    name.isNotEmpty
                                        ? name.split(' ').last.substring(0, 1)
                                        : 'P',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
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
                            Text(
                              AppTranslations.tr('personal_info_header'),
                              style: headingStyle,
                            ),
                            const SizedBox(height: 8),
                            _infoCard(isDark, [
                              _infoRow(
                                Icons.phone,
                                AppTranslations.tr('phone_label'),
                                _value('phone'),
                                bodyStyle,
                                captionStyle,
                              ),
                              _divider(),
                              _infoRow(
                                Icons.cake,
                                AppTranslations.tr('dob_label'),
                                _formatDate(_value('dob', fallback: '')),
                                bodyStyle,
                                captionStyle,
                              ),
                              _divider(),
                              _infoRow(
                                Icons.person,
                                AppTranslations.tr('gender_label'),
                                _genderText(),
                                bodyStyle,
                                captionStyle,
                              ),
                              _divider(),
                              _infoRow(
                                Icons.location_on,
                                AppTranslations.tr('address_label'),
                                _value('address'),
                                bodyStyle,
                                captionStyle,
                              ),
                              _divider(),
                              _infoRow(
                                Icons.water_drop,
                                AppTranslations.tr('blood_group_label'),
                                _value('bloodType'),
                                bodyStyle,
                                captionStyle,
                              ),
                            ]),
                            const SizedBox(height: 20),
                            Text(
                              AppTranslations.tr('activity_header'),
                              style: headingStyle,
                            ),
                            const SizedBox(height: 8),
                            _actionCard(
                              context,
                              isDark,
                              Icons.calendar_today,
                              AppTranslations.tr('my_appointments'),
                              AppTranslations.tr('manage_appointments'),
                              () => Navigator.pushNamed(
                                context,
                                RouteNames.appointmentList,
                              ),
                              bodyStyle,
                              captionStyle,
                            ),
                            _actionCard(
                              context,
                              isDark,
                              Icons.star_rate,
                              AppTranslations.tr('rate_doctor'),
                              AppTranslations.tr('rate_doctor_desc'),
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ReviewListScreen(),
                                  ),
                                );
                              },
                              bodyStyle,
                              captionStyle,
                            ),
                            const SizedBox(height: 8),

                            _actionCard(
                              context,
                              isDark,
                              Icons.message_outlined,
                              'Tin nhắn với bác sĩ',
                              'Trao đổi trực tiếp với bác sĩ điều trị',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const PatientChatRoomsScreen(),
                                  ),
                                );
                              },
                              bodyStyle,
                              captionStyle,
                            ),
                            const SizedBox(height: 8),
                            _actionCard(
                              context,
                              isDark,
                              Icons.folder_open,
                              AppTranslations.tr('medical_records'),
                              AppTranslations.tr('medical_history_desc'),
                              () => Navigator.pushNamed(
                                context,
                                RouteNames.medicalRecordList,
                              ),
                              bodyStyle,
                              captionStyle,
                            ),
                            const SizedBox(height: 8),
                            _actionCard(
                              context,
                              isDark,
                              Icons.medication,
                              AppTranslations.tr('prescriptions'),
                              AppTranslations.tr('prescriptions_desc'),
                              () => Navigator.pushNamed(
                                context,
                                RouteNames.prescriptionList,
                              ),
                              bodyStyle,
                              captionStyle,
                            ),
                            const SizedBox(height: 8),
                            _actionCard(
                              context,
                              isDark,
                              Icons.settings,
                              AppTranslations.tr('settings'),
                              AppTranslations.tr('settings_desc'),
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SettingsScreen(),
                                ),
                              ),
                              bodyStyle,
                              captionStyle,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  await SettingsManager.clearSession();
                                  if (context.mounted) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RouteNames.login,
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                ),
                                label: Text(
                                  AppTranslations.tr('logout'),
                                  style: const TextStyle(color: Colors.red),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoCard(bool isDark, List<Widget> children) => Card(
    margin: EdgeInsets.zero,
    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
    child: Column(children: children),
  );

  Widget _infoRow(
    IconData icon,
    String label,
    String value,
    TextStyle bodyStyle,
    TextStyle captionStyle,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: captionStyle),
              const SizedBox(height: 2),
              Text(value, style: bodyStyle),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _divider() => const Divider(height: 1, indent: 48);

  Widget _actionCard(
    BuildContext context,
    bool isDark,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
    TextStyle bodyStyle,
    TextStyle captionStyle,
  ) => Card(
    margin: EdgeInsets.zero,
    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
                  Text(title, style: bodyStyle),
                  Text(subtitle, style: captionStyle),
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
    if (iso.isEmpty || iso.length < 10)
      return iso.isEmpty ? 'Chưa cập nhật' : iso;
    final parts = iso.split('-');
    if (parts.length < 3) return iso;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}
