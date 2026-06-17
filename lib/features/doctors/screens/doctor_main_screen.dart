import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'doctor_appointments_screen.dart';
import 'doctor_patients_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctor_schedule_screen.dart';
import 'doctor_profile_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctor_prescriptions_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctor_medical_records_screen.dart';
import 'package:care4u_medical_booking/features/chat/presentation/screens/doctor_chat_rooms_screen.dart';

import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class DoctorSession {
  static int get currentDoctorId => SettingsManager.currentDoctorId;
}

class DoctorMainScreen extends StatefulWidget {
  const DoctorMainScreen({super.key});

  @override
  State<DoctorMainScreen> createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DoctorDashboardTab(),
    DoctorAppointmentsScreen(),
    DoctorPatientsScreen(),
    DoctorProfileScreen(),
    DoctorChatRoomsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = SettingsManager.isDarkMode;
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: AppTranslations.tr('dashboard_title'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today_outlined),
            activeIcon: const Icon(Icons.calendar_today),
            label: AppTranslations.tr('nav_appointments'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline),
            activeIcon: const Icon(Icons.people),
            label: AppTranslations.tr('patients'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: AppTranslations.tr('personal_profile'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.message_outlined),
            activeIcon: const Icon(Icons.message),
            label: AppTranslations.tr('chat_action'),
          ),
        ],
      ),
    );
  }
}

class DoctorDashboardTab extends StatefulWidget {
  const DoctorDashboardTab({super.key});

  @override
  State<DoctorDashboardTab> createState() => _DoctorDashboardTabState();
}

class _DoctorDashboardTabState extends State<DoctorDashboardTab> {
   int currentDoctorId = DoctorSession.currentDoctorId;

  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _doctor;
  List<Map<String, dynamic>> _appointments = [];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final doctor = await _api.getObject('/Doctors/$currentDoctorId');
      final appointments = await _api.getAppointments();
      if (!mounted) return;

      setState(() {
        _doctor = doctor;
        _appointments = appointments.where((a) {
          final doctorId = int.tryParse('${a['doctorId']}');
          return doctorId == currentDoctorId;
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = '${AppTranslations.tr('cannot_load_overview_error')}: $e';
        _isLoading = false;
      });
    }
  }

  String _doctorText(String key, [String fallback = 'Chưa cập nhật']) {
    final value = _doctor?[key];
    if (value == null || '$value'.trim().isEmpty) return fallback;
    return '$value';
  }

  List<Map<String, dynamic>> get _todayAppts {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    final list = _appointments.where((a) {
      final status = '${a['status'] ?? ''}'.toLowerCase();
      if (status == 'cancelled' || status == 'da_huy') return false;
      
      final dateRaw = '${a['scheduleDate'] ?? a['appointmentDate'] ?? a['date'] ?? a['createdAt'] ?? ''}';
      if (dateRaw.isEmpty) return false;
      final dateOnly = dateRaw.substring(0, 10);
      return dateOnly == todayStr;
    }).toList();

    list.sort((x, y) {
      final tx = '${x['startTime'] ?? x['time'] ?? '00:00'}';
      final ty = '${y['startTime'] ?? y['time'] ?? '00:00'}';
      return tx.compareTo(ty);
    });
    return list;
  }

  List<Map<String, dynamic>> get _completedAppts {
    return _appointments
        .where((a) => '${a['status'] ?? ''}'.toLowerCase() == 'completed')
        .toList();
  }

  String _formatDateTime(dynamic value) {
    final raw = '${value ?? ''}';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw.isEmpty ? AppTranslations.tr('not_updated') : raw;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = SettingsManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadDashboard,
                  child: Text(AppTranslations.tr('retry')),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final name = _doctorText('fullName', AppTranslations.tr('doctor_label'));
    final specialty = _doctorText('specialtyName', AppTranslations.tr('specialties'));
    final rating = '${_doctor?['rating'] ?? 0}';

    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 160,
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2BB5A0), Color(0xFF1A7A6E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: Colors.white,
                            child: Text(
                              name.split(' ').last.substring(0, 1),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTranslations.tr('welcome_back'),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  specialty,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            onPressed: _loadDashboard,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _statsCard(
                          AppTranslations.tr('patients_today'),
                          '${_todayAppts.length}',
                          Icons.calendar_today,
                          Colors.blue,
                          cardColor,
                          textColor,
                        ),
                        const SizedBox(width: 10),
                        _statsCard(
                          AppTranslations.tr('completed'),
                          '${_completedAppts.length}',
                          Icons.check_circle,
                          AppColors.success,
                          cardColor,
                          textColor,
                        ),
                        const SizedBox(width: 10),
                        _statsCard(
                          AppTranslations.tr('rating'),
                          rating,
                          Icons.star,
                          Colors.amber,
                          cardColor,
                          textColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppTranslations.tr('upcoming_appointments'),
                      style: AppTextStyles.heading2.copyWith(color: textColor),
                    ),
                    const SizedBox(height: 10),
                    ..._todayAppts.take(3).map((a) => _appointmentCard(a, cardColor, textColor, subTextColor)),
                    if (_todayAppts.isEmpty)
                      _EmptyCard(
                        message: AppTranslations.tr('no_upcoming_appointments'),
                        cardColor: cardColor,
                        textColor: subTextColor,
                      ),
                    const SizedBox(height: 20),
                    Text(
                      AppTranslations.tr('quick_actions'),
                      style: AppTextStyles.heading2.copyWith(color: textColor),
                    ),
                    const SizedBox(height: 10),
                    _quickActionsGrid(context, cardColor, textColor, subTextColor),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsCard(String label, String value, IconData icon, Color color, Color cardColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.captionLight.copyWith(color: textColor.withOpacity(0.6)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _appointmentCard(Map<String, dynamic> a, Color cardColor, Color textColor, Color subTextColor) {
    final todayList = _todayAppts;
    final index = todayList.indexWhere((item) => '${item['id']}' == '${a['id']}');
    final sttText = index != -1 ? 'STT: ${index + 1}' : 'STT: -';
    final roomText = '${AppTranslations.tr('room_label')} ${100 + currentDoctorId}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${a['patientName'] ?? '${AppTranslations.tr('patient_label')} #${a['patientId']}'}',
                  style: AppTextStyles.bodyDark.copyWith(color: textColor),
                ),
                Row(
                  children: [
                    Text(
                      '${a['appointmentNo'] ?? ''}',
                      style: AppTextStyles.captionLight.copyWith(color: subTextColor),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        sttText,
                        style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        roomText,
                        style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatDateTime(a['createdAt']),
                  style: AppTextStyles.captionLight.copyWith(color: subTextColor),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppTranslations.tr('upcoming'),
              style: const TextStyle(
                color: AppColors.success,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionsGrid(BuildContext context, Color cardColor, Color textColor, Color subTextColor) {
    final actions = [
      {
        'icon': Icons.add_circle_outline,
        'label': AppTranslations.tr('add_schedule'),
        'color': Colors.blue,
      },
      {
        'icon': Icons.description_outlined,
        'label': AppTranslations.tr('prescriptions'),
        'color': Colors.purple,
      },
      {'icon': Icons.history, 'label': AppTranslations.tr('history_label'), 'color': Colors.orange},
      {
        'icon': Icons.message_outlined,
        'label': AppTranslations.tr('chat_action'),
        'color': Colors.teal,
      },
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      children: actions.map((a) {
        final icon = a['icon'] as IconData;
        final label = a['label'] as String;
        final color = a['color'] as Color;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            if (label == AppTranslations.tr('chat_action')) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DoctorChatRoomsScreen(),
                ),
              );

              if (mounted) {
                _loadDashboard();
              }

              return;
            }
            if (label == AppTranslations.tr('history_label')) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DoctorMedicalRecordsScreen(),
                ),
              );

              if (mounted) {
                _loadDashboard();
              }

              return;
            }
            if (label == AppTranslations.tr('add_schedule')) {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DoctorScheduleScreen()),
              );

              if (mounted) {
                _loadDashboard();
              }

              return;
            }
            if (label == AppTranslations.tr('prescriptions')) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DoctorPrescriptionsScreen(),
                ),
              );

              if (mounted) {
                _loadDashboard();
              }

              return;
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.captionLight.copyWith(color: subTextColor),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  final Color cardColor;
  final Color textColor;

  const _EmptyCard({required this.message, required this.cardColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(child: Text(message, style: AppTextStyles.captionLight.copyWith(color: textColor))),
    );
  }
}

