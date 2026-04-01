import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'constants/app_strings.dart';
import 'theme/app_theme.dart';

class Care4uApp extends StatelessWidget {
  const Care4uApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
