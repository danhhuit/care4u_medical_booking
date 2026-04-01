import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'admin_users_screen.dart';
import 'admin_appointments_screen.dart';
import 'admin_doctors_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalUsers = MockData.adminUsers.length;
    final activeUsers = MockData.adminUsers.where((u) => u['isActive'] == true).length;
    final totalAppointments = MockData.appointments.length;
    final todayAppointments = MockData.appointments
        .where((a) => a['date'] == '2026-04-01')
        .length;
    final totalDoctors =
        MockData.doctors.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Quản trị hệ thống'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeBanner(),
            const SizedBox(height: 20),
            Text('Tổng quan', style: AppTextStyles.heading2),
            const SizedBox(height: 12),
            _statsGrid(
              totalUsers: totalUsers,
              activeUsers: activeUsers,
              totalAppointments: totalAppointments,
              todayAppointments: todayAppointments,
              totalDoctors: totalDoctors,
            ),
            const SizedBox(height: 24),
            Text('Quản lý', style: AppTextStyles.heading2),
            const SizedBox(height: 12),
            _managementCards(context),
            const SizedBox(height: 24),
            Text('Lịch hẹn gần đây', style: AppTextStyles.heading2),
            const SizedBox(height: 12),
            _recentAppointments(),
          ],
        ),
      ),
    );
  }

  Widget _welcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào, Admin!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Hệ thống đang hoạt động bình thường.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _statsGrid({
    required int totalUsers,
    required int activeUsers,
    required int totalAppointments,
    required int todayAppointments,
    required int totalDoctors,
  }) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _statCard('Người dùng', totalUsers.toString(), Icons.people, Colors.blue),
        _statCard('Đang hoạt động', activeUsers.toString(), Icons.verified_user, AppColors.success),
        _statCard('Lịch hẹn', totalAppointments.toString(), Icons.calendar_month, Colors.orange),
        _statCard('Hôm nay', todayAppointments.toString(), Icons.today, Colors.purple),
        _statCard('Bác sĩ', totalDoctors.toString(), Icons.medical_services, AppColors.primary),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color),
          ),
          Text(label, style: AppTextStyles.captionLight),
        ],
      ),
    );
  }

  Widget _managementCards(BuildContext context) {
    final items = [
      _ManagementItem(
        icon: Icons.manage_accounts,
        title: 'Người dùng',
        subtitle: 'Quản lý tài khoản',
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminUsersScreen()),
        ),
      ),
      _ManagementItem(
        icon: Icons.calendar_today,
        title: 'Lịch hẹn',
        subtitle: 'Quản lý đặt lịch',
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminAppointmentsScreen()),
        ),
      ),
      _ManagementItem(
        icon: Icons.local_hospital,
        title: 'Bác sĩ',
        subtitle: 'Quản lý hồ sơ bác sĩ',
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminDoctorsScreen()),
        ),
      ),
    ];

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: item.onTap,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: item.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(item.icon, color: item.color),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: AppTextStyles.bodyDark),
                            Text(item.subtitle, style: AppTextStyles.captionLight),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textLight),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _recentAppointments() {
    final recent = MockData.appointments.take(3).toList();
    return Column(
      children: recent.map((a) {
        Color statusColor;
        String statusLabel;
        switch (a['status']) {
          case 'confirmed':
            statusColor = AppColors.success;
            statusLabel = 'Xác nhận';
            break;
          case 'completed':
            statusColor = Colors.blue;
            statusLabel = 'Hoàn thành';
            break;
          default:
            statusColor = Colors.orange;
            statusLabel = 'Chờ';
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.calendar_today, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a['doctorName']!, style: AppTextStyles.bodyDark),
                    Text('${a['date']} lúc ${a['time']}',
                        style: AppTextStyles.captionLight),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ManagementItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ManagementItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
