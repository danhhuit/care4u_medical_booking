import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/features/appointments/screens/appointments_screen.dart';
import 'package:care4u_medical_booking/features/home/presentation/screens/home_screen.dart';
import 'package:care4u_medical_booking/features/medical_records/screens/medical_record_list_screen.dart';
import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/patient_profile_screen.dart';
import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Care4UApiService _api = Care4UApiService();

  int _currentIndex = 0;

  String _patientName = 'Người dùng';
  String _patientPhone = '';

  final List<Widget> _screens = const [
    HomeScreen(),
    AppointmentsScreen(),
    MedicalRecordListScreen(),
    PatientProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentPatient();
  }

  String get _patientInitial {
    final name = _patientName.trim();
    if (name.isEmpty) return 'U';
    return name[0].toUpperCase();
  }

  Future<void> _loadCurrentPatient() async {
    try {
      final patientId = SettingsManager.currentPatientId;
      final patient = await _api.getPatientById(patientId);

      if (!mounted) return;

      setState(() {
        _patientName = '${patient['fullName'] ?? 'Người dùng'}'.trim();
        _patientPhone = '${patient['phone'] ?? ''}'.trim();
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _patientName = 'Người dùng';
        _patientPhone = '';
      });
    }
  }

  void _onTap(int index) {
    setState(() => _currentIndex = index);

    // Khi quay lại Home hoặc Profile thì tải lại thông tin bệnh nhân.
    if (index == 0 || index == 3) {
      _loadCurrentPatient();
    }
  }

  void _onBookTap() {
    Navigator.pushNamed(context, RouteNames.mapBooking);
  }

  Future<void> _logout() async {
    await SettingsManager.clearSession();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context, isDark),
      body: IndexedStack(index: _currentIndex, children: _screens),
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
              _navItem(
                0,
                Icons.home_outlined,
                Icons.home,
                AppTranslations.tr('nav_home'),
              ),
              _navItem(
                1,
                Icons.calendar_today_outlined,
                Icons.calendar_today,
                AppTranslations.tr('nav_appointments'),
              ),
              const SizedBox(width: 56),
              _navItem(
                2,
                Icons.assignment_outlined,
                Icons.assignment,
                'Hồ sơ bệnh án',
              ),
              _navItem(
                3,
                Icons.person_outline,
                Icons.person,
                AppTranslations.tr('nav_profile'),
              ),
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

  Widget _buildDrawer(BuildContext context, bool isDark) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : AppColors.primary,
            ),
            accountName: Text(
              _patientName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(
              _patientPhone.isNotEmpty
                  ? _patientPhone
                  : 'Chưa cập nhật số điện thoại',
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _patientInitial,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          _drawerItem(Icons.home, AppTranslations.tr('nav_home'), 0),
          _drawerItem(
            Icons.calendar_today,
            AppTranslations.tr('nav_appointments'),
            1,
          ),
          _drawerItem(Icons.assignment, 'Hồ sơ bệnh án', 2),
          _drawerItem(Icons.person, AppTranslations.tr('nav_profile'), 3),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppTranslations.tr('settings')),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              AppTranslations.tr('logout'),
              style: const TextStyle(color: Colors.red),
            ),
            onTap: _logout,
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
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.primary : null,
          fontWeight: isActive ? FontWeight.bold : null,
        ),
      ),
      selected: isActive,
      onTap: () {
        Navigator.pop(context);
        _onTap(index);
      },
    );
  }
}
