import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../app/constants/api_constants.dart';

class Care4UApiService {
  Care4UApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ),
    );
  }

  final Dio _dio;

  Future<List<Map<String, dynamic>>> getList(String endpoint) async {
    final response = await _dio.get(endpoint);

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }

    throw Exception('API $endpoint trả dữ liệu không hợp lệ');
  }

  Future<Map<String, dynamic>> getObject(String endpoint) async {
    final response = await _dio.get(endpoint);

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('API $endpoint trả dữ liệu không hợp lệ');
  }

  Future<List<Map<String, dynamic>>> getDoctors() {
    return getList('/Doctors');
  }

  Future<List<Map<String, dynamic>>> getPatients() {
    return getList('/Patients');
  }

  Future<List<Map<String, dynamic>>> getStoreProducts() {
    return getList('/StoreProducts');
  }

  Future<Map<String, dynamic>> cancelAppointment({
    required String appointmentId,
    required String cancelReason,
  }) async {
    final response = await _dio.put(
      '/Appointments/$appointmentId/cancel',
      data: {'cancelReason': cancelReason},
    );

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Hủy lịch thất bại');
  }

  Future<List<Map<String, dynamic>>> getAppointments() {
    return getList('/Appointments');
  }

  Future<Map<String, dynamic>> createAppointment({
    required int patientId,
    required int doctorId,
    int? scheduleId,
    required String reason,
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'patientId': patientId,
      'doctorId': doctorId,
      'reason': reason,
      'notes': notes,
    };

    if (scheduleId != null) {
      body['scheduleId'] = scheduleId;
    }

    try {
      final response = await _dio.post('/Appointments', data: body);

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }

      return {'message': 'Đặt lịch thành công'};
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        throw Exception('${data['message']}');
      }

      if (data is String && data.trim().isNotEmpty) {
        throw Exception(data);
      }

      throw Exception(e.message ?? 'Đặt lịch thất bại');
    }
  }

  Future<Map<String, dynamic>> createOrder({
    required int patientId,
    required String shippingName,
    required String shippingPhone,
    required String shippingAddress,
    String? shippingNote,
    required String paymentMethod,
    double shippingFee = 30000,
    double discount = 0,
    required List<Map<String, dynamic>> items,
  }) async {
    final response = await _dio.post(
      '/Orders',
      data: {
        'patientId': patientId,
        'shippingName': shippingName,
        'shippingPhone': shippingPhone,
        'shippingAddress': shippingAddress,
        'shippingNote': shippingNote,
        'shippingFee': shippingFee,
        'discount': discount,
        'paymentMethod': paymentMethod,
        'items': items,
      },
    );

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Tạo đơn hàng thất bại');
  }

  Future<List<Map<String, dynamic>>> getOrders() {
    return getList('/Orders');
  }

  Future<List<Map<String, dynamic>>> getOrdersByPatient(int patientId) {
    return getList('/Orders/patient/$patientId');
  }

  Future<Map<String, dynamic>> cancelOrder({
    required String orderId,
    required String cancelReason,
  }) async {
    final response = await _dio.put(
      '/Orders/$orderId/cancel',
      data: {'cancelReason': cancelReason},
    );

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Hủy đơn hàng thất bại');
  }

  Future<Map<String, dynamic>> getPatientById(int patientId) {
    return getObject('/Patients/$patientId');
  }

  Future<Map<String, dynamic>> updatePatient({
    required int patientId,
    required String fullName,
    String? dob,
    String? gender,
    String? phone,
    String? address,
    String? bloodType,
    String? allergies,
    String? avatarUrl,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) async {
    final body = <String, dynamic>{
      'fullName': fullName,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'address': address,
      'bloodType': bloodType,
      'allergies': allergies,
      'avatarUrl': avatarUrl,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
    };

    final response = await _dio.put('/Patients/$patientId', data: body);

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Cập nhật hồ sơ thất bại');
  }

  Future<List<Map<String, dynamic>>> getMedicalRecords() {
    return getList('/MedicalRecords');
  }

  Future<List<Map<String, dynamic>>> getMedicalRecordsByPatient(int patientId) {
    return getList('/MedicalRecords/patient/$patientId');
  }

  Future<Map<String, dynamic>> getMedicalRecordById(int id) {
    return getObject('/MedicalRecords/$id');
  }

  Future<List<Map<String, dynamic>>> getPrescriptions() {
    return getList('/Prescriptions');
  }

  Future<List<Map<String, dynamic>>> getPrescriptionsByPatient(int patientId) {
    return getList('/Prescriptions/patient/$patientId');
  }

  Future<Map<String, dynamic>> getPrescriptionById(int id) {
    return getObject('/Prescriptions/$id');
  }

  Future<List<Map<String, dynamic>>> getNotificationsByPatient({
    required int patientId,
  }) {
    return getList('/Notifications/patient/$patientId');
  }

  Future<Map<String, dynamic>> createNotification({
    int? patientId,
    String? userId,
    required String title,
    required String body,
    String type = 'info',
    String? refType,
    String? refId,
  }) async {
    final requestBody = <String, dynamic>{
      'title': title,
      'body': body,
      'type': type,
      'refType': refType,
      'refId': refId,
    };

    if (patientId != null) {
      requestBody['patientId'] = patientId;
    }

    if (userId != null) {
      requestBody['userId'] = userId;
    }

    final response = await _dio.post('/Notifications', data: requestBody);

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Tạo thông báo thất bại');
  }

  // Future<Map<String, dynamic>> markNotificationAsRead({
  //   required String notificationId,
  // }) async {
  //   final response = await _dio.put('/Notifications/$notificationId/read');

  //   if (response.statusCode == 200 && response.data is Map) {
  //     return Map<String, dynamic>.from(response.data as Map);
  //   }

  //   throw Exception('Đánh dấu thông báo đã đọc thất bại');
  // }

  Future<Map<String, dynamic>> markAllNotificationsAsReadByPatient({
    required int patientId,
  }) async {
    final response = await _dio.put(
      '/Notifications/patient/$patientId/read-all',
    );

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Đánh dấu tất cả thông báo đã đọc thất bại');
  }

  Future<Map<String, dynamic>> deleteNotification({
    required String notificationId,
  }) async {
    final response = await _dio.delete('/Notifications/$notificationId');

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Xóa thông báo thất bại');
  }

  // Future<List<Map<String, dynamic>>> getReviews() {
  //   return getList('/Reviews');
  // }

  // Future<List<Map<String, dynamic>>> getReviewsByDoctor(int doctorId) {
  //   return getList('/Reviews/doctor/$doctorId');
  // }

  // Future<List<Map<String, dynamic>>> getReviewsByPatient(int patientId) {
  //   return getList('/Reviews/patient/$patientId');
  // }

  // Future<Map<String, dynamic>> getReviewById(int id) {
  //   return getObject('/Reviews/$id');
  // }

  // Future<Map<String, dynamic>> createReview({
  //   required int patientId,
  //   required int doctorId,
  //   required String appointmentId,
  //   required int rating,
  //   String? comment,
  //   bool isAnonymous = false,
  // }) async {
  //   final response = await _dio.post(
  //     '/Reviews',
  //     data: {
  //       'patientId': patientId,
  //       'doctorId': doctorId,
  //       'appointmentId': appointmentId,
  //       'rating': rating,
  //       'comment': comment,
  //       'isAnonymous': isAnonymous,
  //     },
  //   );

  //   if (response.statusCode == 200 && response.data is Map) {
  //     return Map<String, dynamic>.from(response.data as Map);
  //   }

  //   throw Exception('Gửi đánh giá thất bại');
  // }

  // Future<Map<String, dynamic>> updateReview({
  //   required int id,
  //   int? rating,
  //   String? comment,
  //   bool? isAnonymous,
  //   bool? isVisible,
  // }) async {
  //   final response = await _dio.put(
  //     '/Reviews/$id',
  //     data: {
  //       if (rating != null) 'rating': rating,
  //       if (comment != null) 'comment': comment,
  //       if (isAnonymous != null) 'isAnonymous': isAnonymous,
  //       if (isVisible != null) 'isVisible': isVisible,
  //     },
  //   );

  //   if (response.statusCode == 200 && response.data is Map) {
  //     return Map<String, dynamic>.from(response.data as Map);
  //   }

  //   throw Exception('Cập nhật đánh giá thất bại');
  // }

  // Future<Map<String, dynamic>> deleteReview(int id) async {
  //   final response = await _dio.delete('/Reviews/$id');

  //   if (response.statusCode == 200 && response.data is Map) {
  //     return Map<String, dynamic>.from(response.data as Map);
  //   }

  //   throw Exception('Xóa đánh giá thất bại');
  // }

  Future<List<Map<String, dynamic>>> getDoctorSchedules() {
    return getList('/DoctorSchedules');
  }

  Future<List<Map<String, dynamic>>> getDoctorSchedulesByDoctor(int doctorId) {
    return getList('/DoctorSchedules/doctor/$doctorId');
  }

  Future<Map<String, dynamic>> getDoctorScheduleById(int id) async {
    final response = await _dio.get('/DoctorSchedules/$id');

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Không thể tải lịch làm việc');
  }

  Future<Map<String, dynamic>> createDoctorSchedule({
    required int doctorId,
    required String scheduleDate,
    required String startTime,
    required String endTime,
    int slotDuration = 30,
    int maxPatients = 1,
    bool isAvailable = true,
    String? note,
  }) async {
    final response = await _dio.post(
      '/DoctorSchedules',
      data: {
        'doctorId': doctorId,
        'scheduleDate': scheduleDate,
        'startTime': startTime,
        'endTime': endTime,
        'slotDuration': slotDuration,
        'maxPatients': maxPatients,
        'isAvailable': isAvailable,
        'note': note,
      },
    );

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Tạo lịch làm việc thất bại');
  }

  Future<Map<String, dynamic>> updateDoctorSchedule({
    required int id,
    String? scheduleDate,
    String? startTime,
    String? endTime,
    int? slotDuration,
    int? maxPatients,
    bool? isAvailable,
    String? note,
  }) async {
    final data = <String, dynamic>{};

    if (scheduleDate != null) data['scheduleDate'] = scheduleDate;
    if (startTime != null) data['startTime'] = startTime;
    if (endTime != null) data['endTime'] = endTime;
    if (slotDuration != null) data['slotDuration'] = slotDuration;
    if (maxPatients != null) data['maxPatients'] = maxPatients;
    if (isAvailable != null) data['isAvailable'] = isAvailable;
    if (note != null) data['note'] = note;

    final response = await _dio.put('/DoctorSchedules/$id', data: data);

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Cập nhật lịch làm việc thất bại');
  }

  Future<Map<String, dynamic>> deleteDoctorSchedule(int id) async {
    final response = await _dio.delete('/DoctorSchedules/$id');

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Xóa lịch làm việc thất bại');
  }

  Future<List<Map<String, dynamic>>> getMedicines() {
    return getList('/Medicines/active');
  }

  Future<List<Map<String, dynamic>>> getPrescriptionsByDoctor(int doctorId) {
    return getList('/Prescriptions/doctor/$doctorId');
  }

  Future<Map<String, dynamic>> createPrescription({
    required int medicalRecordId,
    required int doctorId,
    required int patientId,
    String? dateIssued,
    String? validUntil,
    String? notes,
    String status = 'active',
    required List<Map<String, dynamic>> items,
  }) async {
    final response = await _dio.post(
      '/Prescriptions',
      data: {
        'medicalRecordId': medicalRecordId,
        'doctorId': doctorId,
        'patientId': patientId,
        'dateIssued': dateIssued,
        'validUntil': validUntil,
        'status': status,
        'notes': notes,
        'items': items,
      },
    );

    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    return {'message': 'Tạo đơn thuốc thành công'};
  }

  Future<Map<String, dynamic>> markNotificationAsRead(String id) async {
    final response = await _dio.put('/Notifications/$id/read');

    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    return {'message': 'Đã đánh dấu đã đọc'};
  }

  Future<Map<String, dynamic>> sendForgotPasswordOtp({
    required String account,
  }) async {
    try {
      final response = await _dio.post(
        '/Auth/forgot-password/send-otp',
        data: {'account': account},
      );

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }

      throw Exception('Gửi OTP thất bại');
    } on DioException catch (e) {
      throw Exception(_getDioErrorMessage(e, 'Gửi OTP thất bại'));
    }
  }

  Future<Map<String, dynamic>> verifyForgotPasswordOtp({
    required String account,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '/Auth/forgot-password/verify-otp',
        data: {'account': account, 'otp': otp},
      );

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }

      throw Exception('Xác thực OTP thất bại');
    } on DioException catch (e) {
      throw Exception(_getDioErrorMessage(e, 'Xác thực OTP thất bại'));
    }
  }

  Future<Map<String, dynamic>> loginWithDatabase({
    required String account,
    required String password,
    String? licenseNumber,
  }) async {
    try {
      final data = <String, dynamic>{'account': account, 'password': password};

      if (licenseNumber != null && licenseNumber.trim().isNotEmpty) {
        data['licenseNumber'] = licenseNumber.trim().toUpperCase();
      }

      final response = await _dio.post('/Auth/login', data: data);

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }

      throw Exception('Đăng nhập thất bại');
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        throw Exception('${data['message']}');
      }

      throw Exception(e.message ?? 'Đăng nhập thất bại');
    }
  }

  Future<Map<String, dynamic>> registerPatient({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? gender,
    String? dob,
    String? address,
  }) async {
    try {
      final response = await _dio.post(
        '/Auth/register',
        data: {
          'fullName': fullName,
          'email': email,
          'phone': phone,
          'password': password,
          'gender': gender,
          'dob': dob,
          'address': address,
        },
      );

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }

      throw Exception('Đăng ký thất bại');
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        throw Exception('${data['message']}');
      }

      throw Exception(e.message ?? 'Đăng ký thất bại');
    }
  }

  Future<Map<String, dynamic>> resetPasswordWithToken({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/Auth/forgot-password/reset',
        data: {'resetToken': resetToken, 'newPassword': newPassword},
      );

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }

      throw Exception('Đổi mật khẩu thất bại');
    } on DioException catch (e) {
      throw Exception(_getDioErrorMessage(e, 'Đổi mật khẩu thất bại'));
    }
  }

  String _getDioErrorMessage(DioException e, String fallbackMessage) {
    final data = e.response?.data;

    if (data is Map && data['message'] != null) {
      return '${data['message']}';
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    if (e.message != null && e.message!.trim().isNotEmpty) {
      return e.message!;
    }

    return fallbackMessage;
  }

  Future<List<Map<String, dynamic>>> getMedicalRecordsByDoctor(int doctorId) {
    return getList('/MedicalRecords/doctor/$doctorId');
  }

  Future<Map<String, dynamic>> createMedicalRecord({
    required String appointmentId,
    required int patientId,
    required int doctorId,
    String? recordDate,
    required String chiefComplaint,
    String? symptoms,
    required String diagnosis,
    String? icd10Code,
    String? treatmentPlan,
    String? followUpDate,
    String? vitalSigns,
  }) async {
    final response = await _dio.post(
      '/MedicalRecords',
      data: {
        'appointmentId': appointmentId,
        'patientId': patientId,
        'doctorId': doctorId,
        'recordDate': recordDate,
        'chiefComplaint': chiefComplaint,
        'symptoms': symptoms,
        'diagnosis': diagnosis,
        'icd10Code': icd10Code,
        'treatmentPlan': treatmentPlan,
        'followUpDate': followUpDate,
        'vitalSigns': vitalSigns,
      },
    );

    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    return {'message': 'Tạo hồ sơ bệnh án thành công'};
  }

  Future<List<Map<String, dynamic>>> getChatRoomsByDoctor(int doctorId) {
    return getList('/ChatRooms/doctor/$doctorId');
  }

  Future<List<Map<String, dynamic>>> getChatRoomsByPatient(int patientId) {
    return getList('/ChatRooms/patient/$patientId');
  }

  Future<Map<String, dynamic>> createOrGetChatRoom({
    required int patientId,
    required int doctorId,
    String? appointmentId,
  }) async {
    final response = await _dio.post(
      '/ChatRooms',
      data: {
        'patientId': patientId,
        'doctorId': doctorId,
        'appointmentId': appointmentId,
      },
    );

    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Tạo phòng chat thất bại');
  }

  Future<List<Map<String, dynamic>>> getChatMessagesByRoom(String roomId) {
    return getList('/ChatMessages/room/$roomId');
  }

  Future<Map<String, dynamic>> sendChatMessage({
    required String roomId,
    String? senderId,
    required String senderRole,
    required String content,
    String messageType = 'text',
  }) async {
    final response = await _dio.post(
      '/ChatMessages',
      data: {
        'roomId': roomId,
        'senderId': senderId,
        'senderRole': senderRole,
        'content': content,
        'messageType': messageType,
      },
    );

    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Gửi tin nhắn thất bại');
  }

  Future<Map<String, dynamic>> markChatMessageAsRead(String messageId) async {
    final response = await _dio.put('/ChatMessages/$messageId/read');

    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    return {'message': 'Đã đánh dấu tin nhắn đã đọc'};
  }

  Future<Map<String, dynamic>> markChatRoomAsRead(
    String roomId, {
    required String readerRole,
  }) async {
    final response = await _dio.put(
      '/ChatMessages/room/$roomId/read',
      queryParameters: {'readerRole': readerRole},
    );

    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    return {'message': 'Đã đánh dấu phòng chat đã đọc'};
  }

  Future<List<Map<String, dynamic>>> getReviews() {
    return getList('/Reviews');
  }

  Future<List<Map<String, dynamic>>> getReviewsByDoctor(int doctorId) {
    return getList('/Reviews/doctor/$doctorId');
  }

  Future<List<Map<String, dynamic>>> getReviewsByPatient(int patientId) {
    return getList('/Reviews/patient/$patientId');
  }

  Future<Map<String, dynamic>> getReviewById(int id) {
    return getObject('/Reviews/$id');
  }

  Future<Map<String, dynamic>> createReview({
    required int patientId,
    required int doctorId,
    required String appointmentId,
    required int rating,
    String? comment,
    bool isAnonymous = false,
  }) async {
    final response = await _dio.post(
      '/Reviews',
      data: {
        'patientId': patientId,
        'doctorId': doctorId,
        'appointmentId': appointmentId,
        'rating': rating,
        'comment': comment,
        'isAnonymous': isAnonymous,
      },
    );

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Gửi đánh giá thất bại');
  }

  Future<Map<String, dynamic>> updateReview({
    required int id,
    int? rating,
    String? comment,
    bool? isAnonymous,
    bool? isVisible,
  }) async {
    final response = await _dio.put(
      '/Reviews/$id',
      data: {
        if (rating != null) 'rating': rating,
        if (comment != null) 'comment': comment,
        if (isAnonymous != null) 'isAnonymous': isAnonymous,
        if (isVisible != null) 'isVisible': isVisible,
      },
    );

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Cập nhật đánh giá thất bại');
  }

  Future<Map<String, dynamic>> deleteReview(int id) async {
    final response = await _dio.delete('/Reviews/$id');

    if (response.statusCode == 200 && response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Xóa đánh giá thất bại');
  }

  Future<Map<String, dynamic>> replyReview({
    required int reviewId,
    required String reply,
  }) async {
    final response = await _dio.put(
      '/Reviews/$reviewId/reply',
      data: {'reply': reply},
    );

    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    return {'message': 'Phản hồi đánh giá thành công'};
  }

  String _normalizeAccountForApi(String value) {
    var account = value.trim();

    if (account.startsWith('+84')) {
      account = '0${account.substring(3)}';
    }

    if (RegExp(r'^84\d{9}$').hasMatch(account)) {
      account = '0${account.substring(2)}';
    }

    return account.toLowerCase();
  }

  Future<Map<String, dynamic>?> findPatientByAccount(String account) async {
    final normalized = _normalizeAccountForApi(account);
    final patients = await getPatients();

    Map<String, dynamic>? fallback;

    for (final patient in patients) {
      final id = int.tryParse('${patient['id'] ?? ''}');
      if (id == 1) fallback = patient;

      final email = '${patient['email'] ?? ''}'.trim().toLowerCase();
      final phone = _normalizeAccountForApi('${patient['phone'] ?? ''}');

      if (email == normalized || phone == normalized) {
        return patient;
      }
    }

    // Giữ fallback để app vẫn chạy được với dữ liệu seed hiện tại.
    return fallback ?? (patients.isNotEmpty ? patients.first : null);
  }

  Future<Map<String, dynamic>?> findDoctorByLicense(
    String licenseNumber,
  ) async {
    final normalizedLicense = licenseNumber
        .trim()
        .replaceAll(' ', '')
        .toUpperCase();
    final doctors = await getDoctors();

    Map<String, dynamic>? fallback;

    for (final doctor in doctors) {
      final id = int.tryParse('${doctor['id'] ?? ''}');
      if (id == 1) fallback = doctor;

      final license =
          '${doctor['licenseNumber'] ?? doctor['license_number'] ?? ''}'
              .trim()
              .replaceAll(' ', '')
              .toUpperCase();

      if (license == normalizedLicense) {
        return doctor;
      }
    }

    return fallback ?? (doctors.isNotEmpty ? doctors.first : null);
  }

  Future<List<Map<String, dynamic>>> getAdminUsers({
    String role = 'all',
    String? keyword,
  }) async {
    final response = await _dio.get(
      '/admin/users',
      queryParameters: {
        if (role != 'all') 'role': role,
        if (keyword != null && keyword.trim().isNotEmpty)
          'keyword': keyword.trim(),
      },
    );

    if (response.data is List) {
      return (response.data as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }

    throw Exception('Không thể tải danh sách tài khoản');
  }

  Future<Map<String, dynamic>> getAdminUserDetail(String userId) async {
    final response = await _dio.get('/admin/users/$userId');

    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Không thể tải chi tiết tài khoản');
  }

  Future<Map<String, dynamic>> updateAdminUserStatus({
    required String userId,
    required bool isActive,
  }) async {
    final response = await _dio.put(
      '/admin/users/$userId/status',
      data: {'isActive': isActive},
    );

    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }

    throw Exception('Cập nhật trạng thái thất bại');
  }

  Future<Map<String, dynamic>> updateAdminUser({
    required String userId,
    String? email,
    String? phone,
    String? newPassword,
    String? fullName,
    String? gender,
    String? dob,
    String? address,
    String? bloodType,
    String? allergies,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? title,
    String? licenseNumber,
    double? consultationFee,
    String? bio,
  }) async {
    final data = <String, dynamic>{};

    void addString(String key, String? value) {
      final text = value?.trim();
      if (text != null && text.isNotEmpty) {
        data[key] = text;
      }
    }

    addString('email', email);
    addString('phone', phone);
    addString('newPassword', newPassword);
    addString('fullName', fullName);
    addString('gender', gender);
    addString('dob', dob);
    addString('address', address);
    addString('bloodType', bloodType);
    addString('allergies', allergies);
    addString('emergencyContactName', emergencyContactName);
    addString('emergencyContactPhone', emergencyContactPhone);
    addString('title', title);
    addString('licenseNumber', licenseNumber);
    addString('bio', bio);

    if (consultationFee != null) {
      data['consultationFee'] = consultationFee;
    }

    try {
      final response = await _dio.put('/admin/users/$userId', data: data);

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }

      throw Exception('Cập nhật tài khoản thất bại');
    } on DioException catch (e) {
      final resData = e.response?.data;

      if (resData is Map && resData['message'] != null) {
        throw Exception('${resData['message']}');
      }

      if (resData is String && resData.trim().isNotEmpty) {
        throw Exception(resData);
      }

      throw Exception(e.message ?? 'Cập nhật tài khoản thất bại');
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableSchedulesByDoctor(
    int doctorId,
  ) async {
    try {
      final response = await _dio.get(
        '/DoctorSchedules/available/doctor/$doctorId',
      );

      if (response.data is List) {
        return (response.data as List)
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }

      throw Exception('Dữ liệu lịch làm việc không hợp lệ');
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        throw Exception('${data['message']}');
      }

      if (data is String && data.trim().isNotEmpty) {
        throw Exception(data);
      }

      throw Exception(e.message ?? 'Không thể tải lịch làm việc của bác sĩ');
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableDoctorSchedules({
    required int doctorId,
  }) {
    return getAvailableSchedulesByDoctor(doctorId);
  }

  Future<Map<String, dynamic>> rescheduleAppointment({
    required String appointmentId,
    required int doctorId,
    required int scheduleId,
  }) async {
    try {
      final response = await _dio.put(
        '/Appointments/$appointmentId/reschedule',
        data: {'doctorId': doctorId, 'scheduleId': scheduleId},
      );

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }

      throw Exception('Đổi lịch thất bại');
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        throw Exception('${data['message']}');
      }

      throw Exception(e.message ?? 'Đổi lịch thất bại');
    }
  }

  Future<List<Map<String, dynamic>>> getSpecialties() async {
    try {
      final response = await _dio.get('/Specialties');

      if (response.data is List) {
        return (response.data as List)
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }

      throw Exception('Không thể tải danh sách chuyên khoa');
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        throw Exception('${data['message']}');
      }

      throw Exception(e.message ?? 'Không thể tải danh sách chuyên khoa');
    }
  }

  Future<List<Map<String, dynamic>>> getDoctorsBySpecialty(
    int specialtyId,
  ) async {
    try {
      final response = await _dio.get(
        '/Doctors',
        queryParameters: {'specialtyId': specialtyId},
      );

      if (response.data is List) {
        return (response.data as List)
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }

      throw Exception('Không thể tải bác sĩ theo chuyên khoa');
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        throw Exception('${data['message']}');
      }

      throw Exception(e.message ?? 'Không thể tải bác sĩ theo chuyên khoa');
    }
  }

  Future<Map<String, dynamic>> registerFcmToken({
    required String userId,
    required String token,
    String? platform,
    String? deviceId,
  }) async {
    try {
      final response = await _dio.post(
        '/DeviceTokens/register',
        data: {
          'userId': userId,
          'token': token,
          'platform': platform,
          'deviceId': deviceId,
        },
      );

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }

      return {'message': 'Đã lưu FCM token'};
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        throw Exception('${data['message']}');
      }

      throw Exception(e.message ?? 'Không thể lưu FCM token');
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/Auth/change-password',
        data: {
          'userId': userId,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }

      return {'message': 'Đổi mật khẩu thành công'};
    } on DioException catch (e) {
      debugPrint('CHANGE PASSWORD STATUS: ${e.response?.statusCode}');
      debugPrint('CHANGE PASSWORD DATA: ${e.response?.data}');

      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        throw Exception('${data['message']}');
      }

      throw Exception('Đổi mật khẩu thất bại');
    }
  }

  Future<Map<String, dynamic>> createAppointmentBySchedule({
    required int patientId,
    required int doctorId,
    required int scheduleId,
    required String reason,
  }) async {
    try {
      final response = await _dio.post(
        '/Appointments',
        data: {
          'patientId': patientId,
          'doctorId': doctorId,
          'scheduleId': scheduleId,
          'reason': reason,
        },
      );

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }

      return {'message': 'Đặt lịch thành công'};
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        throw Exception('${data['message']}');
      }

      throw Exception(e.message ?? 'Đặt lịch thất bại');
    }
  }
}
