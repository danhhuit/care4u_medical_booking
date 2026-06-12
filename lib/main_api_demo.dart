import 'package:flutter/material.dart';
import 'features/api_demo/screens/api_demo_home_screen.dart';

void main() {
  runApp(const Care4UApiDemoApp());
}

class Care4UApiDemoApp extends StatelessWidget {
  const Care4UApiDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care4U API Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const ApiDemoHomeScreen(),
    );
  }
}
