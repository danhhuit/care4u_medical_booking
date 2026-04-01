import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/features/home/presentation/screens/home_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctors_screen.dart';
import 'package:care4u_medical_booking/features/payments/presentation/screens/payments_home_screen.dart';
import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/patient_profile_screen.dart';
import 'package:care4u_medical_booking/features/appointments/screens/appointments_screen.dart';
import 'package:care4u_medical_booking/features/notifications/presentation/screens/notification_list_screen.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Tabs: Home | Appointments | [Book FAB] | Payments | Profile
  final List<Widget> _screens = const [
    HomeScreen(),
    AppointmentsScreen(),
    PaymentsHomeScreen(walletBalance: 1500000),
    PatientProfileScreen(),
  ];

  int get _unreadCount =>
      MockData.notifications.where((n) => n['isRead'] == false).length;

  void _onTap(int index) {
    setState(() => _currentIndex = index);
  }

  void _onBookTap() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onBookTap,
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white, size: 22),
            Text(
              'Đặt lịch',
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_outlined, Icons.home, 'Trang chủ'),
              _navItem(1, Icons.calendar_today_outlined, Icons.calendar_today, 'Lịch hẹn'),
              const SizedBox(width: 56), // FAB space
              _navItemWithBadge(2, Icons.account_balance_wallet_outlined,
                  Icons.account_balance_wallet, 'Thanh toán'),
              _navItem(3, Icons.person_outline, Icons.person, 'Cá nhân'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;
    return InkWell(
      onTap: () => _onTap(index),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : Colors.grey,
              size: 24,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? AppColors.primary : Colors.grey,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItemWithBadge(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;
    return InkWell(
      onTap: () => _onTap(index),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : Colors.grey,
              size: 24,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? AppColors.primary : Colors.grey,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
