import 'package:care4u_medical_booking/app/router/route_args.dart';
import 'package:care4u_medical_booking/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:care4u_medical_booking/features/appointments/screens/appointments_screen.dart';
import 'package:care4u_medical_booking/features/appointments/screens/book_appointment_screen.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/login_phone_screen.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/register_screen.dart';
import 'package:care4u_medical_booking/features/auth/presentation/screens/splash_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctor_detail_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctors_screen.dart';
import 'package:care4u_medical_booking/features/health_center/health_center_page.dart';
import 'package:care4u_medical_booking/features/home/presentation/screens/main_screen.dart';
import 'package:care4u_medical_booking/features/medical_records/history_page.dart';
import 'package:care4u_medical_booking/features/notifications/presentation/screens/notification_list_screen.dart';
import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/edit_profile_screen.dart';
import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/patient_profile_screen.dart';
import 'package:care4u_medical_booking/features/payments/domain/entities/transaction_entity.dart';
import 'package:care4u_medical_booking/features/payments/presentation/screens/payment_qr_screen.dart';
import 'package:care4u_medical_booking/features/payments/presentation/screens/payments_home_screen.dart';
import 'package:care4u_medical_booking/features/payments/presentation/screens/topup_screen.dart';
import 'package:care4u_medical_booking/features/payments/presentation/screens/transaction_history_screen.dart';
import 'package:care4u_medical_booking/features/reviews/presentation/screens/review_doctor_screen.dart';
import 'package:care4u_medical_booking/features/reviews/presentation/screens/review_list_screen.dart';
import 'package:care4u_medical_booking/features/specialties/screens/specialties_screen.dart';
import 'package:care4u_medical_booking/features/prescriptions/prescription_list_page.dart';
import 'package:flutter/material.dart';
import 'route_names.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/error_view.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
// import '../../core/widgets/empty_state.dart';

class AppRouter {
  AppRouter._();
  static const String initialRoute = RouteNames.splash;
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ─── Splash ─────────────────────────────────────────────────────────────
      case RouteNames.splash:
        return _buildRoute(
          settings,
          const SplashScreen(),
        );

      // ─── Auth ───────────────────────────────────────────────────────────────
      case RouteNames.login:
        return _buildRoute(settings, const LoginPhoneScreen());

      case RouteNames.register:
        return _buildRoute(settings, const RegisterScreen());

      case RouteNames.forgotPassword:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Quên mật khẩu'),
        );

      // ─── Main ───────────────────────────────────────────────────────────────
      case RouteNames.home:
        return _buildRoute(settings, const MainScreen());

      // ─── Patient Profile ────────────────────────────────────────────────────
      case RouteNames.patientProfile:
        return _buildRoute(settings, const PatientProfileScreen());

      case RouteNames.editPatientProfile:
        return _buildRoute(settings, const EditProfileScreen());

      // ─── Doctors ────────────────────────────────────────────────────────────
      case RouteNames.doctorList:
        return _buildRoute(settings, const DoctorsScreen());

      case RouteNames.doctorDetail:
        final args = settings.arguments;
        if (args is DoctorDetailRouteArgs) {
          return _buildRoute(
            settings,
            DoctorDetailScreen(
              doctorData: const {
                'id': '1',
                'name': 'BS. Nguyễn Văn An',
                'specialty': 'Tim mạch',
                'imageUrl': 'assests/images/default_doctor.jpg',
                'rating': 4.8,
                'reviews': 120,
                'bio': 'Bác sĩ An có hơn 10 năm kinh nghiệm trong lĩnh vực Tim mạch.',
                'hospital': 'BV Chợ Rẫy',
                'fee': 300000,
              },
            ),
          );
        }
        if (args is Map<String, dynamic>) {
          return _buildRoute(settings, DoctorDetailScreen(doctorData: args));
        }
        return _undefinedRoute(message: 'Doctor detail requires args');

      // ─── Specialties ────────────────────────────────────────────────────────
      case RouteNames.specialtyList:
        return _buildRoute(settings, const SpecialtiesScreen());

      // ─── Appointments ───────────────────────────────────────────────────────
      case RouteNames.appointmentList:
        return _buildRoute(settings, const AppointmentsScreen());

      case RouteNames.appointmentBooking:
        final args = settings.arguments;
        if (args is AppointmentBookingRouteArgs) {
          return _buildRoute(
            settings,
            BookAppointmentScreen(
              doctorData: const {
                'id': '1',
                'name': 'BS. Nguyễn Văn An',
                'specialty': 'Tim mạch',
                'imageUrl': 'assests/images/default_doctor.jpg',
              },
            ),
          );
        }
        if (args is Map<String, dynamic>) {
          return _buildRoute(settings, BookAppointmentScreen(doctorData: args));
        }
        return _buildRoute(
          settings,
          const BookAppointmentScreen(
            doctorData: {
              'id': '1',
              'name': 'BS. Nguyễn Văn An',
              'specialty': 'Tim mạch',
              'imageUrl': 'assests/images/default_doctor.jpg',
            },
          ),
        );


      case RouteNames.appointmentDetail:
      case RouteNames.appointmentSuccess:
        return _buildRoute(
          settings,
          const AppointmentsScreen(),
        );

      // ─── Medical Records ────────────────────────────────────────────────────
      case RouteNames.medicalRecordList:
      case RouteNames.medicalRecordDetail:
        return _buildRoute(settings, const HistoryPage());

      case RouteNames.prescriptionList:
        return _buildRoute(settings, const PrescriptionListPage());

      // ─── Notifications ──────────────────────────────────────────────────────
      case RouteNames.notificationList:
        return _buildRoute(settings, const NotificationListScreen());

      // ─── Payments ───────────────────────────────────────────────────────────
      case RouteNames.paymentsHome:
        return _buildRoute(
          settings,
          const PaymentsHomeScreen(walletBalance: 1500000),
        );

      case RouteNames.paymentTopup:
        return _buildRoute(settings, const TopupScreen());

      case RouteNames.paymentQr:
        return _buildRoute(settings, const PaymentQrScreen());

      case RouteNames.paymentHistory:
        return _buildRoute(
          settings,
          TransactionHistoryScreen(
            transactions: [
              TransactionEntity(
                id: '1',
                title: 'Thanh toán khám bệnh',
                amount: -200000,
                type: 'appointmentPayment',
                status: 'succeeded',
                createdAt: DateTime(2026, 3, 8),
              ),
              TransactionEntity(
                id: '2',
                title: 'Nạp tiền vào ví',
                amount: 500000,
                type: 'topup',
                status: 'succeeded',
                createdAt: DateTime(2026, 3, 7),
              ),
            ],
          ),
        );

      // ─── Reviews ────────────────────────────────────────────────────────────
      case RouteNames.reviewDoctor:
        final args = settings.arguments;
        if (args is Map<String, dynamic>) {
          return _buildRoute(
            settings,
            ReviewDoctorScreen(
              doctorId: args['doctorId'] as String?,
              doctorName: args['doctorName'] as String?,
              isReadOnly: args['isReadOnly'] as bool? ?? false,
            ),
          );
        }
        return _buildRoute(settings, const ReviewListScreen());

      // ─── Health Center ───────────────────────────────────────────────────────
      case RouteNames.healthCenterMap:
      case RouteNames.healthCenterDetail:
        return _buildRoute(settings, const HealthCenterPage());

      // ─── Admin ──────────────────────────────────────────────────────────────
      case RouteNames.adminDashboard:
        return _buildRoute(settings, const AdminDashboardScreen());

      default:
        return _undefinedRoute(
          message: 'Không tìm thấy route: ${settings.name}',
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
        appBar: AppBar(title: const Text('Lỗi điều hướng')),
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
