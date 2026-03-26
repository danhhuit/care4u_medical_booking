class RouteNames {
  RouteNames._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main
  static const String home = '/home';

  // Patient
  static const String patientProfile = '/patient-profile';
  static const String editPatientProfile = '/edit-patient-profile';

  // Doctors
  static const String doctorList = '/doctor-list';
  static const String doctorDetail = '/doctor-detail';
  static const String specialtyList = '/specialty-list';

  // Appointments
  static const String appointmentList = '/appointment-list';
  static const String appointmentDetail = '/appointment-detail';
  static const String appointmentBooking = '/appointment-booking';
  static const String appointmentSuccess = '/appointment-success';

  // Medical records
  static const String medicalRecordList = '/medical-record-list';
  static const String medicalRecordDetail = '/medical-record-detail';

  // Notifications
  static const String notificationList = '/notification-list';

  // Payments
  static const String paymentHistory = '/payment-history';
  static const String paymentsHome = '/payments';
  static const String paymentTopup = '/payments/topup';
  static const String paymentQr = '/payments/qr';

  // Reviews
  static const String reviewDoctor = '/review-doctor';

  // Health center
  static const String healthCenterMap = '/health-center-map';
  static const String healthCenterDetail = '/health-center-detail';

  // Admin
  static const String adminDashboard = '/admin-dashboard';
}
