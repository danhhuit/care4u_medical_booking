import 'package:flutter/material.dart';
import '../../core/widgets/empty_state.dart';
import 'route_names.dart';

class AppRouter {
  static const String initialRoute = RouteNames.home;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: SafeArea(
              child: Center(
                child: EmptyState(
                  title: 'Care4U',
                  message: 'Project starter is ready.',
                ),
              ),
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: SafeArea(child: Center(child: Text('Route not found'))),
          ),
        );
    }
  }
}
