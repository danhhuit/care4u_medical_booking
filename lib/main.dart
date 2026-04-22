import 'package:flutter/material.dart';
// import 'package:care4u_medical_booking/app/app.dart';
import 'package:care4u_medical_booking/features/admin/presentation/screens/admin_management_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Care4U Admin',
      home: AdminManagementScreen(),
    );
  }
}