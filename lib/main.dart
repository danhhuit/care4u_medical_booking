import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/app.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsManager.init();
  await MockData.init();
  runApp(const Care4uApp());
}
