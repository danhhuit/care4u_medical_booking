import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/config/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  runApp(const Care4uApp());
}
