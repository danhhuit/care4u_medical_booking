import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_theme.dart';
import 'package:care4u_medical_booking/app/router/app_router.dart';
import 'package:care4u_medical_booking/app/constants/app_strings.dart';

class Care4uApp extends StatefulWidget {
  const Care4uApp({super.key});

  @override
  State<Care4uApp> createState() => _Care4uAppState();
}

class _Care4uAppState extends State<Care4uApp> {
  // Keeping a GlobalKey for the Navigator ensures that the navigation stack
  // is preserved even if the MaterialApp widget itself is rebuilt due to theme/language changes.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SettingsManager.themeMode,
      builder: (context, mode, _) {
        return ValueListenableBuilder<String>(
          valueListenable: SettingsManager.languageCode,
          builder: (context, lang, _) {
            return MaterialApp(
              key: const ValueKey('care4u_material_app'), // Stable key for the MaterialApp
              navigatorKey: _navigatorKey, // Essential to preserve navigation state
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
              // By providing navigatorKey, MaterialApp won't re-initialize the Navigator
              // to the initialRoute on every rebuild.
              initialRoute: AppRouter.initialRoute,
              onGenerateRoute: AppRouter.onGenerateRoute,
              locale: Locale(lang),
            );
          },
        );
      },
    );
  }
}
