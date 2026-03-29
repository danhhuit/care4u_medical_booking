import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/config/dependency_injection.dart';
// import 'package:care4u_medical_booking/features/auth/presentation/screens/login_doctor_screen.dart';
// import 'package:care4u_medical_booking/features/auth/presentation/screens/login_doctor_screen.dart';
// import 'package:care4u_medical_booking/features/auth/presentation/screens/register_screen.dart';
// import 'package:care4u_medical_booking/features/auth/presentation/screens/otp_verification_screen.dart';
// import 'package:care4u_medical_booking/features/auth/presentation/screens/reset_password_screen.dart';
// import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/update_profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  runApp(const Care4uApp());
}

// đây là main để test giao diện đăng nhập
// void main() {
//   runApp(const TestApp());
// }

// class TestApp extends StatelessWidget {
//   const TestApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false, // Ẩn dải ruy-băng chữ DEBUG màu đỏ cho đẹp
//       title: 'UI Test Care4U',
      
//       // 3. THAY ĐỔI TÊN CLASS MÀN HÌNH Ở ĐÂY ĐỂ XEM
//       home: const LoginDoctorScreen(), 
      
//     );
//   }
// }