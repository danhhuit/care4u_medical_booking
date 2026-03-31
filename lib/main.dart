import 'package:flutter/material.dart';
// import 'features/doctors/screens/doctors_screen.dart';
// import 'features/appointments/screens/appointments_screen.dart';
import 'features/specialties/screens/specialties_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UI Testing',
      home: const SpecialtiesScreen(), 
    ),
  );
}
