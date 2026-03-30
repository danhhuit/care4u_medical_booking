import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/config/dependency_injection.dart';
import 'features/prescriptions/prescription_list_page.dart';
import 'features/prescriptions/prescription_detail_page.dart';
import 'features/prescriptions/revisit_schedule_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PrescriptionDetailPage(),
  ));
}


