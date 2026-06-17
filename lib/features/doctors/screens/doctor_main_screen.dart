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
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Lịch hẹn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Bệnh nhân',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Tin nhắn',
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
        _errorMessage = 'Không thể tải dữ liệu tổng quan: $e';
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
    if (dt == null) return raw.isEmpty ? 'Chưa cập nhật' : raw;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
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
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final name = _doctorText('fullName', 'Bác sĩ');
    final specialty = _doctorText('specialtyName', 'Chuyên khoa');
    final rating = '${_doctor?['rating'] ?? 0}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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
                                const Text(
                                  'Chào mừng trở lại,',
                                  style: TextStyle(
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
                          'Bệnh nhân hôm nay',
                          '${_todayAppts.length}',
                          Icons.calendar_today,
                          Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        _statsCard(
                          'Hoàn thành',
                          '${_completedAppts.length}',
                          Icons.check_circle,
                          AppColors.success,
                        ),
                        const SizedBox(width: 10),
                        _statsCard(
                          'Đánh giá',
                          rating,
                          Icons.star,
                          Colors.amber,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Lịch hẹn sắp tới', style: AppTextStyles.heading2),
                    const SizedBox(height: 10),
                    ..._todayAppts.take(3).map((a) => _appointmentCard(a)),
                    if (_todayAppts.isEmpty)
                      const _EmptyCard(message: 'Không có lịch hẹn sắp tới'),
                    const SizedBox(height: 20),
                    Text('Nhanh chóng', style: AppTextStyles.heading2),
                    const SizedBox(height: 10),
                    _quickActionsGrid(context),
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

  Widget _statsCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
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
              style: AppTextStyles.captionLight,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _appointmentCard(Map<String, dynamic> a) {
    final todayList = _todayAppts;
    final index = todayList.indexWhere((item) => '${item['id']}' == '${a['id']}');
    final sttText = index != -1 ? 'STT: ${index + 1}' : 'STT: -';
    final roomText = 'Phòng ${100 + currentDoctorId}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  '${a['patientName'] ?? 'Bệnh nhân #${a['patientId']}'}',
                  style: AppTextStyles.bodyDark,
                ),
                Row(
                  children: [
                    Text(
                      '${a['appointmentNo'] ?? ''}',
                      style: AppTextStyles.captionLight,
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
                  style: AppTextStyles.captionLight,
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
            child: const Text(
              'Sắp tới',
              style: TextStyle(
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

  Widget _quickActionsGrid(BuildContext context) {
    final actions = [
      {
        'icon': Icons.add_circle_outline,
        'label': 'Thêm lịch',
        'color': Colors.blue,
      },
      {
        'icon': Icons.description_outlined,
        'label': 'Đơn thuốc',
        'color': Colors.purple,
      },
      {'icon': Icons.history, 'label': 'Lịch sử', 'color': Colors.orange},
      {
        'icon': Icons.message_outlined,
        'label': 'Tin nhắn',
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
            if (label == 'Tin nhắn') {
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
            if (label == 'Lịch sử') {
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
            if (label == 'Thêm lịch') {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DoctorScheduleScreen()),
              );

              if (mounted) {
                _loadDashboard();
              }

              return;
            }
            if (label == 'Đơn thuốc') {
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

            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('$label sẽ được làm ở bước tiếp theo')),
            // );
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
                style: AppTextStyles.captionLight,
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

  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(child: Text(message, style: AppTextStyles.captionLight)),
    );
  }
}

