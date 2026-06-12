import 'package:flutter/material.dart';
import 'features/doctors/screens/api_doctors_screen.dart';

void main() {
  runApp(const DoctorsApiApp());
}

class DoctorsApiApp extends StatelessWidget {
  const DoctorsApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care4U Doctors API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const ApiDoctorsScreen(),
    );
  }
}
