import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:care4u_medical_booking/app/app.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Firebase với cấu hình tuỳ chỉnh cho từng nền tảng
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Tắt xác thực reCAPTCHA (bỏ qua trình duyệt web) khi test trên Máy ảo
  await FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  
  await SettingsManager.init();
  await MockData.init();
  runApp(const Care4uApp());
}
