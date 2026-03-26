import 'package:care4u_medical_booking/app/router/route_args.dart';
import 'package:flutter/material.dart';
import 'route_names.dart';
import '../../core/widgets/error_view.dart';
// import '../../core/widgets/empty_state.dart';
// import '../../app/constants/app_strings.dart';
// import '../../app/constants/app_enums.dart';

class AppRouter {
  AppRouter._();
  static const String initialRoute = RouteNames.home;
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Splash Screen'),
        );

      case RouteNames.login:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Login Screen'),
        );

      case RouteNames.register:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Register Screen'),
        );

      case RouteNames.home:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Home Screen'),
        );

      case RouteNames.doctorList:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Doctor List Screen'),
        );

      case RouteNames.doctorDetail:
        final args = settings.arguments;
        if (args is DoctorDetailRouteArgs) {
          return _buildRoute(
            settings,
            _PlaceholderScreen(title: 'Doctor Detail: ${args.doctorId}'),
          );
        }
        return _undefinedRoute(
          message: 'Doctor detail requires DoctorDetailRouteArgs',
        );

      case RouteNames.appointmentBooking:
        final args = settings.arguments;
        if (args is AppointmentBookingRouteArgs) {
          return _buildRoute(
            settings,
            _PlaceholderScreen(
              title:
                  'Booking: doctor=${args.doctorId}, specialty=${args.specialtyId}',
            ),
          );
        }
        return _undefinedRoute(
          message: 'Appointment booking requires AppointmentBookingRouteArgs',
        );

      case RouteNames.patientProfile:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Patient Profile Screen'),
        );

      case RouteNames.notificationList:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Notification List Screen'),
        );

      case RouteNames.healthCenterMap:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Health Center Map Screen'),
        );

      default:
        return _undefinedRoute(
          message: 'No route defined for ${settings.name}',
        );
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget page,
  ) {
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }

  static MaterialPageRoute<dynamic> _undefinedRoute({String? message}) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Route Error')),
        body: Center(child: ErrorView(message: message ?? 'Route not found')),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title đang được phát triển',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
