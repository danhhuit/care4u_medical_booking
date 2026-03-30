import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/config/dependency_injection.dart';
import 'features/health_center/health_center_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();


  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HealthCenterPage(),
  ));
}
