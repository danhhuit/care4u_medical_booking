import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'doctor_appointments_screen.dart';
import 'doctor_patients_screen.dart';
import 'doctor_schedule_screen.dart';
import 'doctor_profile_screen.dart';

/// Mock current logged-in doctor
class DoctorSession {
  static Map<String, dynamic> currentDoctor = {
    'id': '1',
    'name': 'BS. Nguyễn Văn An',
    'specialty': 'Tim mạch',
    'hospital': 'BV Chợ Rẫy',
    'imageUrl': 'assests/images/bacsi_1.jpg',
    'rating': 4.8,
    'reviews': 120,
    'phone': '0901234567',
    'email': 'bsnguyen@care4u.vn',
    'experience': '10 năm',
    'licenseId': 'BS-2025-001',
  };
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
        ],
      ),
    );
  }
}

// ─── Dashboard Tab ────────────────────────────────────────────────────────────
class DoctorDashboardTab extends StatelessWidget {
  const DoctorDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = DoctorSession.currentDoctor;
    final todayAppts = MockData.appointments
        .where((a) => a['status'] == 'confirmed')
        .toList();
    final completedAppts = MockData.appointments
        .where((a) => a['status'] == 'completed')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.white,
                          child: Text(
                            doctor['name'].toString().split(' ').last.substring(0, 1),
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
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                              Text(
                                doctor['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                doctor['specialty']!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                          onPressed: () {},
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
                  // Stats row
                  Row(
                    children: [
                      _statsCard('Lịch hôm nay', '${todayAppts.length}',
                          Icons.calendar_today, Colors.blue),
                      const SizedBox(width: 10),
                      _statsCard('Hoàn thành', '${completedAppts.length}',
                          Icons.check_circle, AppColors.success),
                      const SizedBox(width: 10),
                      _statsCard('Đánh giá', '${doctor['rating']}',
                          Icons.star, Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Lịch hẹn sắp tới', style: AppTextStyles.heading2),
                  const SizedBox(height: 10),
                  ...todayAppts.take(3).map((a) => _appointmentCard(a)),
                  if (todayAppts.isEmpty)
                    const _EmptyCard(message: 'Không có lịch hẹn hôm nay'),
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
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: AppTextStyles.captionLight, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _appointmentCard(Map<String, dynamic> a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child:
              const Icon(Icons.person, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Bệnh nhân ${a['id']}', style: AppTextStyles.bodyDark),
            Text('${a['date']} • ${a['time']}',
                style: AppTextStyles.captionLight),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('Xác nhận',
              style: TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }

  Widget _quickActionsGrid(BuildContext context) {
    final actions = [
      {'icon': Icons.add_circle_outline, 'label': 'Thêm lịch', 'color': Colors.blue},
      {'icon': Icons.description_outlined, 'label': 'Đơn thuốc', 'color': Colors.purple},
      {'icon': Icons.history, 'label': 'Lịch sử', 'color': Colors.orange},
      {'icon': Icons.message_outlined, 'label': 'Tin nhắn', 'color': Colors.teal},
    ];
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      children: actions
          .map((a) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (a['color'] as Color).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(a['icon'] as IconData,
                        color: a['color'] as Color, size: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(a['label'] as String,
                      style: AppTextStyles.captionLight,
                      textAlign: TextAlign.center,
                      maxLines: 1),
                ],
              ))
          .toList(),
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
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Center(
        child: Text(message, style: AppTextStyles.captionLight),
      ),
    );
  }
}
