import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctor_main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextScreen();
  }

  Future<void> _decideNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (SettingsManager.isLoggedIn) {
      if (SettingsManager.isDoctor) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DoctorMainScreen()),
        );
        return;
      }

      Navigator.pushReplacementNamed(context, RouteNames.home);
      return;
    }

    // Trường hợp Firebase còn session cũ nhưng SettingsManager chưa có role,
    // đưa về login để chọn đúng tài khoản bệnh nhân/bác sĩ và lưu session app.
    if (firebaseUser != null) {
      await SettingsManager.clearSession();
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assests/images/logo.png', height: 120),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Image.asset(
                  'assests/images/quote_banner.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
