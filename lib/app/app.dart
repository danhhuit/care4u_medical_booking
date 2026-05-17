import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_theme.dart';
import 'package:care4u_medical_booking/app/router/app_router.dart';
import 'package:care4u_medical_booking/app/constants/app_strings.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

class Care4uApp extends StatefulWidget {
  const Care4uApp({super.key});

  @override
  State<Care4uApp> createState() => _Care4uAppState();
}

class _Care4uAppState extends State<Care4uApp> {
  late final String _initialRoute;

  @override
  void initState() {
    super.initState();
    _initialRoute = RouteNames.splash;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        SettingsManager.themeMode,
        SettingsManager.languageCode,
      ]),
      builder: (context, _) {
        final mode = SettingsManager.themeMode.value;
        final lang = SettingsManager.languageCode.value;

        return MaterialApp(
          navigatorKey: globalNavigatorKey,
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          initialRoute: _initialRoute,
          onGenerateRoute: AppRouter.onGenerateRoute,
          locale: Locale(lang),
        );
      },
    );
  }
}
