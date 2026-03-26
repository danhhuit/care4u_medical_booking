class ApiConstants {
  ApiConstants._();

  static const String baseUrlDev = 'https://dev-api.care4u.vn/api';
  static const String baseUrlProd = 'https://api.care4u.vn/api';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';

  // User / patient
  static const String patientProfile = '/patients/me';
  static const String updatePatientProfile = '/patients/me/update';

  // Doctors
  static const String doctors = '/doctors';
  static const String doctorDetail = '/doctors/{id}';
  static const String specialties = '/specialties';

  // Appointments
  static const String appointments = '/appointments';
  static const String appointmentDetail = '/appointments/{id}';
  static const String availableSlots = '/appointments/available-slots';
  static const String rescheduleAppointment = '/appointments/{id}/reschedule';
  static const String cancelAppointment = '/appointments/{id}/cancel';

  // Medical records
  static const String medicalRecords = '/medical-records';

  // Notifications
  static const String notifications = '/notifications';
  static const String markNotificationAsRead = '/notifications/{id}/read';

  // Payments
  static const String payments = '/payments';
  static const String paymentHistory = '/payments/history';

  // Reviews
  static const String reviews = '/reviews';

  // Health centers
  static const String healthCenters = '/health-centers';
}
