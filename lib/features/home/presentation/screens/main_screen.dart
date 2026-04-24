import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/features/home/presentation/screens/home_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctors_screen.dart';
import 'package:care4u_medical_booking/features/payments/presentation/screens/payments_home_screen.dart';
import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/patient_profile_screen.dart';
import 'package:care4u_medical_booking/features/appointments/screens/appointments_screen.dart';
// import 'package:care4u_medical_booking/features/notifications/presentation/screens/notification_list_screen.dart';
// import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  // Tabs: Home | Appointments | [Book FAB] | Payments | Profile
  final List<Widget> _screens = [
    const HomeScreen(),
    const AppointmentsScreen(),
    const PaymentsHomeScreen(walletBalance: 1500000),
    const PatientProfileScreen(),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
          key: _scaffoldKey,
          drawer: _buildDrawer(context, isDark),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.white, size: 22),
                Text(
                  AppTranslations.tr('book_appointment_fab'),
                  style: const TextStyle(color: Colors.white, fontSize: 8),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            elevation: 8,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(0, Icons.home_outlined, Icons.home, AppTranslations.tr('nav_home')),
                  _navItem(1, Icons.calendar_today_outlined, Icons.calendar_today, AppTranslations.tr('nav_appointments')),
                  const SizedBox(width: 56), // FAB space
                  _navItemWithBadge(2, Icons.account_balance_wallet_outlined,
                      Icons.account_balance_wallet, AppTranslations.tr('nav_payments')),
                  _navItem(3, Icons.person_outline, Icons.person, AppTranslations.tr('nav_profile')),
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

  Widget _buildDrawer(BuildContext context, bool isDark) {
    final patient = MockData.currentPatient;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : AppColors.primary,
            ),
            accountName: Text(patient['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(patient['phone'] ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                patient['name']!.split(' ').last[0],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
          ),
          _drawerItem(Icons.home, AppTranslations.tr('nav_home'), 0),
          _drawerItem(Icons.calendar_today, AppTranslations.tr('nav_appointments'), 1),
          _drawerItem(Icons.account_balance_wallet, AppTranslations.tr('nav_payments'), 2),
          _drawerItem(Icons.person, AppTranslations.tr('nav_profile'), 3),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppTranslations.tr('settings')),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(AppTranslations.tr('logout'), style: const TextStyle(color: Colors.red)),
            onTap: () {
              SettingsManager.setLoggedIn(false);
              Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (route) => false);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return ListTile(
      leading: Icon(icon, color: isActive ? AppColors.primary : null),
      title: Text(label, style: TextStyle(color: isActive ? AppColors.primary : null, fontWeight: isActive ? FontWeight.bold : null)),
      selected: isActive,
      onTap: () {
        Navigator.pop(context); // Close drawer
        _onTap(index);
      },
    );
  }
}
