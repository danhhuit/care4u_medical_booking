import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';

class DoctorScheduleScreen extends StatelessWidget {
  const DoctorScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch làm việc'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: const Center(
        child: Text('Xem lịch làm việc', style: AppTextStyles.bodyLight),
      ),
    );
  }
}
