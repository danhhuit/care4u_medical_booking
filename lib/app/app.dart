import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_theme.dart';
import 'package:care4u_medical_booking/app/router/app_router.dart';
import 'package:care4u_medical_booking/app/constants/app_strings.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

class Care4uApp extends StatefulWidget {
  const Care4uApp({super.key});

  @override
  State<Care4uApp> createState() => _Care4uAppState();
}

class _Care4uAppState extends State<Care4uApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SettingsManager.themeMode,
      builder: (context, mode, _) {
        return ValueListenableBuilder<String>(
          valueListenable: SettingsManager.languageCode,
          builder: (context, lang, _) {
             return MaterialApp(
              navigatorKey: globalNavigatorKey,
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
              initialRoute: SettingsManager.isLoggedIn ? RouteNames.home : AppRouter.initialRoute,
              onGenerateRoute: AppRouter.onGenerateRoute,
              locale: Locale(lang),
            );
          },
        );
      },
    );
  }
}

