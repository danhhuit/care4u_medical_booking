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

// đây là main để test giao diện đăng nhập
void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Ẩn dải ruy-băng chữ DEBUG màu đỏ cho đẹp
      title: 'UI Test Care4U',
      
      // 3. THAY ĐỔI TÊN CLASS MÀN HÌNH Ở ĐÂY ĐỂ XEM
      home: const LoginDoctorScreen(), 
      
    );
  }
}