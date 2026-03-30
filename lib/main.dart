import 'package:flutter/material.dart';
import 'navigation/main_navigation.dart'; 

void main() {
  runApp(const MedicalApp());
}
class MedicalApp extends StatelessWidget {
  const MedicalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care4U Medical',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(), 
      home: MainNavigation(),
    );
  }
  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
