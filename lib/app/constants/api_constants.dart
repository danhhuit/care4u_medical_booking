class ApiConstants {
  ApiConstants._();

  // Android Emulator dùng 10.0.2.2 thay cho localhost
  static const String baseUrlDev = 'http://10.0.2.2:5130/api';

  // Sau này deploy API thật thì đổi link production ở đây
  static const String baseUrlProd = 'https://your-production-domain.com/api';

  // Hiện tại đang test local API C# nên dùng dev
  static const String baseUrl = baseUrlDev;

  static const String appointments = '$baseUrl/Appointments';
  static const String chatMessages = '$baseUrl/ChatMessages';
  static const String chatRooms = '$baseUrl/ChatRooms';
  static const String doctors = '$baseUrl/Doctors';
  static const String doctorSchedules = '$baseUrl/DoctorSchedules';
  static const String healthCenters = '$baseUrl/HealthCenters';
  static const String medicalRecords = '$baseUrl/MedicalRecords';
  static const String medicines = '$baseUrl/Medicines';
  static const String notifications = '$baseUrl/Notifications';
  static const String orders = '$baseUrl/Orders';
  static const String orderItems = '$baseUrl/OrderItems';
  static const String patients = '$baseUrl/Patients';
  static const String payments = '$baseUrl/Payments';
  static const String prescriptions = '$baseUrl/Prescriptions';
  static const String prescriptionItems = '$baseUrl/PrescriptionItems';
  static const String productCategories = '$baseUrl/ProductCategories';
  static const String reviews = '$baseUrl/Reviews';
  static const String specialties = '$baseUrl/Specialties';
  static const String storeProducts = '$baseUrl/StoreProducts';
  static const String users = '$baseUrl/Users';

  // Các endpoint cũ của payment_remote_datasource.dart
  // Tạm khai báo để app hết lỗi compile.
  // Nếu API C# chưa có các route này thì khi gọi sẽ 404, nhưng app sẽ build được.
  static const String wallet = '$baseUrl/Payments/wallet';
  static const String createPayment = '$baseUrl/Payments';
  static const String topupCreate = '$baseUrl/Payments/topup';
  static const String transactionHistory = '$baseUrl/Payments/transactions';
}
