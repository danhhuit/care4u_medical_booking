import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/config/dependency_injection.dart';
import 'features/medical_records/history_page.dart';
import 'features/medical_records/profile_page.dart';  
import 'features/medical_records/results_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  
  // Comment dòng dưới lại khi muốn chạy toàn bộ app
  // runApp(const Care4uApp());
  
  // Bỏ comment đoạn dưới để chạy thử trang HistoryPage
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
}
