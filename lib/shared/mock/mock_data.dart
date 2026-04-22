import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Mock in-memory data for Care4U app

class MockData {
  MockData._();

  // ─── Doctors ────────────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> doctors = [
    {
      'id': '1',
      'name': 'BS. Nguyễn Văn An',
      'specialty': 'Tim mạch',
      'imageUrl': 'assests/images/bacsi_1.jpg',
      'rating': 4.8,
      'reviews': 120,
      'bio':
          'Bác sĩ An có hơn 10 năm kinh nghiệm trong lĩnh vực Tim mạch, từng tu nghiệp tại Pháp.',
      'hospital': 'BV Chợ Rẫy',
      'fee': 300000,
    },
    {
      'id': '2',
      'name': 'BS. Trần Thị Bình',
      'specialty': 'Nhi khoa',
      'imageUrl': 'assests/images/bacsi_2.jpg',
      'rating': 4.9,
      'reviews': 85,
      'bio': 'Bác sĩ Bình chuyên khoa Nhi, luôn tận tâm và yêu thương trẻ nhỏ.',
      'hospital': 'BV Nhi Đồng 1',
      'fee': 250000,
    },
    {
      'id': '3',
      'name': 'BS. Lê Trọng Chung',
      'specialty': 'Thần kinh',
      'imageUrl': 'assests/images/bacsi_3.jpg',
      'rating': 4.7,
      'reviews': 50,
      'bio':
          'Chuyên gia hàng đầu về các bệnh lý thần kinh và phẫu thuật thần kinh.',
      'hospital': 'BV 115',
      'fee': 350000,
    },
    {
      'id': '4',
      'name': 'BS. Phạm Thị Dung',
      'specialty': 'Da liễu',
      'imageUrl': 'assests/images/bacsi_4.jpg',
      'rating': 4.6,
      'reviews': 200,
      'bio':
          'Bác sĩ Dung có kinh nghiệm phong phú điều trị các bệnh về da và thẩm mỹ da liễu.',
      'hospital': 'BV Da Liễu TP.HCM',
      'fee': 200000,
    },
  ];

  // ─── Specialties ─────────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> specialties = [
    {'id': 's1', 'name': 'Tim mạch', 'icon': 'favorite', 'doctorCount': 12},
    {'id': 's2', 'name': 'Nhi khoa', 'icon': 'child_care', 'doctorCount': 8},
    {'id': 's3', 'name': 'Thần kinh', 'icon': 'psychology', 'doctorCount': 6},
    {'id': 's4', 'name': 'Da liễu', 'icon': 'healing', 'doctorCount': 15},
    {'id': 's5', 'name': 'Mắt', 'icon': 'remove_red_eye', 'doctorCount': 10},
    {'id': 's6', 'name': 'Tai-Mũi-Họng', 'icon': 'hearing', 'doctorCount': 7},
  ];

  // ─── Notifications ────────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> notifications = [
    {
      'id': 'n1',
      'title': 'Nhắc lịch khám',
      'body':
          'Bạn có lịch khám với BS. Nguyễn Văn An vào 09:00 ngày 05/04/2026.',
      'type': 'reminder',
      'isRead': false,
      'time': '2026-04-01T08:00:00',
      'appointmentId': 'a1',
    },
    {
      'id': 'n2',
      'title': 'Lịch hẹn được xác nhận',
      'body':
          'Lịch hẹn ngày 03/04/2026 với BS. Trần Thị Bình đã được xác nhận.',
      'type': 'confirmed',
      'isRead': false,
      'time': '2026-03-30T14:30:00',
      'appointmentId': 'a2',
    },
    {
      'id': 'n3',
      'title': 'Lịch hẹn bị huỷ',
      'body': 'Lịch hẹn ngày 01/04/2026 với BS. Lê Trọng Chung đã bị huỷ.',
      'type': 'cancelled',
      'isRead': true,
      'time': '2026-03-29T10:00:00',
      'appointmentId': 'a4',
    },
    {
      'id': 'n4',
      'title': 'Kết quả xét nghiệm',
      'body': 'Kết quả xét nghiệm máu ngày 28/03/2026 đã có. Nhấn để xem.',
      'type': 'result',
      'isRead': true,
      'time': '2026-03-28T16:45:00',
    },
  ];

  // ─── Reviews ─────────────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> reviews = [
    // ─ BS. Nguyễn Văn An (doctorId: '1') ─
    {
      'id': 'r1', 'doctorId': '1', 'doctorName': 'BS. Nguyễn Văn An',
      'patientName': 'Trần Minh Quân', 'rating': 5,
      'comment': 'Bác sĩ rất tận tâm, giải thích rõ ràng từng bước điều trị. Tôi rất yên tâm sau buổi khám.',
      'date': '2026-04-18', 'time': '09:32',
    },
    {
      'id': 'r2', 'doctorId': '1', 'doctorName': 'BS. Nguyễn Văn An',
      'patientName': 'Lê Thị Hương', 'rating': 5,
      'comment': 'Phòng khám sạch sẽ, bác sĩ nhiệt tình và chuyên nghiệp. Sẽ giới thiệu cho bạn bè.',
      'date': '2026-04-10', 'time': '14:15',
    },
    {
      'id': 'r3', 'doctorId': '1', 'doctorName': 'BS. Nguyễn Văn An',
      'patientName': 'Phạm Văn Đức', 'rating': 4,
      'comment': 'Bác sĩ khám kỹ, cho thuốc hợp lý. Thời gian chờ hơi dài nhưng chất lượng tốt.',
      'date': '2026-04-05', 'time': '10:00',
    },
    {
      'id': 'r4', 'doctorId': '1', 'doctorName': 'BS. Nguyễn Văn An',
      'patientName': 'Nguyễn Thị Thu', 'rating': 5,
      'comment': 'Rất hài lòng! Bác sĩ An đã giúp tôi phát hiện sớm vấn đề tim mạch. Cảm ơn bác sĩ rất nhiều.',
      'date': '2026-03-28', 'time': '08:45',
    },
    {
      'id': 'r5', 'doctorId': '1', 'doctorName': 'BS. Nguyễn Văn An',
      'patientName': 'Đỗ Hoàng Nam', 'rating': 4,
      'comment': 'Tư vấn rõ ràng, dễ hiểu. Bác sĩ lắng nghe bệnh nhân rất tốt.',
      'date': '2026-03-20', 'time': '16:20',
    },
    {
      'id': 'r6', 'doctorId': '1', 'doctorName': 'BS. Nguyễn Văn An',
      'patientName': 'Vũ Thị Lan', 'rating': 5,
      'comment': 'Kinh nghiệm 10 năm thực sự thấy rõ. Bác sĩ chẩn đoán chính xác và nhanh chóng.',
      'date': '2026-03-15', 'time': '11:00',
    },
    // ─ BS. Trần Thị Bình (doctorId: '2') ─
    {
      'id': 'r7', 'doctorId': '2', 'doctorName': 'BS. Trần Thị Bình',
      'patientName': 'Hoàng Văn Minh', 'rating': 5,
      'comment': 'Bác sĩ Bình rất nhẹ nhàng với trẻ em. Con tôi không còn sợ đi khám bệnh nữa!',
      'date': '2026-04-20', 'time': '09:00',
    },
    {
      'id': 'r8', 'doctorId': '2', 'doctorName': 'BS. Trần Thị Bình',
      'patientName': 'Nguyễn Lan Anh', 'rating': 5,
      'comment': 'Con tôi 3 tuổi rất quấy nhưng bác sĩ kiên nhẫn và chăm sóc chu đáo. Rất hài lòng!',
      'date': '2026-04-15', 'time': '14:30',
    },
    {
      'id': 'r9', 'doctorId': '2', 'doctorName': 'BS. Trần Thị Bình',
      'patientName': 'Trần Thị Kim Oanh', 'rating': 4,
      'comment': 'Phòng khám đông nhưng bác sĩ vẫn dành đủ thời gian cho từng bệnh nhân. Tốt!',
      'date': '2026-04-08', 'time': '10:45',
    },
    {
      'id': 'r10', 'doctorId': '2', 'doctorName': 'BS. Trần Thị Bình',
      'patientName': 'Lý Thành Đạt', 'rating': 5,
      'comment': 'Bác sĩ giỏi chuyên môn, tư vấn dinh dưỡng cho trẻ rất hữu ích. Cảm ơn bác sĩ!',
      'date': '2026-03-30', 'time': '08:00',
    },
    {
      'id': 'r11', 'doctorId': '2', 'doctorName': 'BS. Trần Thị Bình',
      'patientName': 'Phạm Quốc Huy', 'rating': 4,
      'comment': 'Bác sĩ chuyên nghiệp. Chẩn đoán chính xác bệnh của con tôi ngay lần đầu.',
      'date': '2026-03-22', 'time': '15:00',
    },
    {
      'id': 'r12', 'doctorId': '2', 'doctorName': 'BS. Trần Thị Bình',
      'patientName': 'Bùi Thị Thanh Nga', 'rating': 5,
      'comment': 'Đội ngũ y tá hỗ trợ tốt, bác sĩ dặn dò kỹ trước khi ra về. Rất tin tưởng!',
      'date': '2026-03-15', 'time': '11:30',
    },
    // ─ BS. Lê Trọng Chung (doctorId: '3') ─
    {
      'id': 'r13', 'doctorId': '3', 'doctorName': 'BS. Lê Trọng Chung',
      'patientName': 'Ngô Thị Bích', 'rating': 5,
      'comment': 'Bác sĩ Chung có chuyên môn cao về thần kinh, giải thích bệnh rất dễ hiểu.',
      'date': '2026-04-19', 'time': '10:00',
    },
    {
      'id': 'r14', 'doctorId': '3', 'doctorName': 'BS. Lê Trọng Chung',
      'patientName': 'Đinh Quang Hải', 'rating': 4,
      'comment': 'Bác sĩ khám cẩn thận, không vội vàng. Bệnh tôi tiến triển tốt sau khi uống thuốc theo toa.',
      'date': '2026-04-12', 'time': '13:30',
    },
    {
      'id': 'r15', 'doctorId': '3', 'doctorName': 'BS. Lê Trọng Chung',
      'patientName': 'Trương Thị Hoa', 'rating': 4,
      'comment': 'Tư vấn rõ về bệnh đau đầu mãn tính của tôi. Phác đồ điều trị hợp lý và hiệu quả.',
      'date': '2026-04-05', 'time': '09:15',
    },
    {
      'id': 'r16', 'doctorId': '3', 'doctorName': 'BS. Lê Trọng Chung',
      'patientName': 'Võ Văn Khoa', 'rating': 5,
      'comment': 'Bác sĩ rất tận tâm, theo dõi tiến trình điều trị chặt chẽ. Gia đình tôi rất biết ơn.',
      'date': '2026-03-29', 'time': '16:00',
    },
    {
      'id': 'r17', 'doctorId': '3', 'doctorName': 'BS. Lê Trọng Chung',
      'patientName': 'Dương Thị Linh', 'rating': 3,
      'comment': 'Bác sĩ giỏi nhưng thời gian chờ khá lâu. Mong cơ sở cải thiện thêm về hẹn lịch.',
      'date': '2026-03-20', 'time': '11:45',
    },
    {
      'id': 'r18', 'doctorId': '3', 'doctorName': 'BS. Lê Trọng Chung',
      'patientName': 'Lê Đình Trường', 'rating': 5,
      'comment': 'Sau 3 tháng điều trị theo hướng dẫn của bác sĩ, bệnh của tôi đã giảm hẳn!',
      'date': '2026-03-10', 'time': '08:30',
    },
    // ─ BS. Phạm Thị Dung (doctorId: '4') ─
    {
      'id': 'r19', 'doctorId': '4', 'doctorName': 'BS. Phạm Thị Dung',
      'patientName': 'Huỳnh Thị Tâm', 'rating': 5,
      'comment': 'Bác sĩ Dung tư vấn chăm sóc da rất chi tiết và dễ thực hiện tại nhà. Rất cảm ơn!',
      'date': '2026-04-21', 'time': '10:30',
    },
    {
      'id': 'r20', 'doctorId': '4', 'doctorName': 'BS. Phạm Thị Dung',
      'patientName': 'Trần Bảo Châu', 'rating': 5,
      'comment': 'Phác đồ điều trị mụn của bác sĩ rất hiệu quả. Da tôi cải thiện rõ rệt sau 4 tuần.',
      'date': '2026-04-14', 'time': '14:00',
    },
    {
      'id': 'r21', 'doctorId': '4', 'doctorName': 'BS. Phạm Thị Dung',
      'patientName': 'Nguyễn Khánh Linh', 'rating': 4,
      'comment': 'Bác sĩ kiến thức sâu về da liễu. Khám rất kỹ, hỏi thăm tình trạng dị ứng trước khi kê thuốc.',
      'date': '2026-04-07', 'time': '09:45',
    },
    {
      'id': 'r22', 'doctorId': '4', 'doctorName': 'BS. Phạm Thị Dung',
      'patientName': 'Phan Thị Mai', 'rating': 5,
      'comment': 'Chữa được bệnh chàm mà tôi bị hơn 2 năm. Rất tin tưởng và sẽ tái khám ở đây.',
      'date': '2026-03-31', 'time': '15:30',
    },
    {
      'id': 'r23', 'doctorId': '4', 'doctorName': 'BS. Phạm Thị Dung',
      'patientName': 'Cao Thành Nhân', 'rating': 4,
      'comment': 'Bác sĩ tư vấn sản phẩm chăm sóc da phù hợp với loại da của tôi. Rất hữu ích.',
      'date': '2026-03-24', 'time': '11:15',
    },
    {
      'id': 'r24', 'doctorId': '4', 'doctorName': 'BS. Phạm Thị Dung',
      'patientName': 'Lưu Thị Ánh', 'rating': 5,
      'comment': 'Bác sĩ Dung rất thân thiện và chuyên nghiệp. Giải thích nguyên nhân bệnh rõ ràng, dễ hiểu.',
      'date': '2026-03-16', 'time': '08:00',
    },
  ];

  // ─── Appointments ─────────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> appointments = [
    {
      'id': 'a1',
      'doctorName': 'BS. Nguyễn Văn An',
      'specialty': 'Tim mạch',
      'date': '2026-04-05',
      'time': '09:00',
      'status': 'confirmed',
      'hospital': 'BV Chợ Rẫy',
    },
    {
      'id': 'a2',
      'doctorName': 'BS. Trần Thị Bình',
      'specialty': 'Nhi khoa',
      'date': '2026-04-03',
      'time': '14:00',
      'status': 'confirmed',
      'hospital': 'BV Nhi Đồng 1',
    },
    {
      'id': 'a3',
      'doctorName': 'BS. Lê Trọng Chung',
      'specialty': 'Thần kinh',
      'date': '2026-03-28',
      'time': '10:00',
      'status': 'completed',
      'hospital': 'BV 115',
    },
    {
      'id': 'a4',
      'doctorName': 'BS. Phạm Thị Dung',
      'specialty': 'Da liễu',
      'date': '2026-04-01',
      'time': '14:30',
      'status': 'cancelled',
      'hospital': 'BV Da Liễu TP.HCM',
    },
  ];

  // ─── Users (Admin) ────────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> adminUsers = [
    {
      'id': 'u1',
      'name': 'Nguyễn Văn Hùng',
      'email': 'hungng@gmail.com',
      'role': 'patient',
      'isActive': true,
      'joinDate': '2025-01-15',
    },
    {
      'id': 'u2',
      'name': 'Lê Thị Mai',
      'email': 'maile@gmail.com',
      'role': 'patient',
      'isActive': true,
      'joinDate': '2025-02-20',
    },
    {
      'id': 'u3',
      'name': 'BS. Nguyễn Văn An',
      'email': 'bsnguyen@care4u.vn',
      'role': 'doctor',
      'isActive': true,
      'joinDate': '2025-01-01',
    },
    {
      'id': 'u4',
      'name': 'BS. Trần Thị Bình',
      'email': 'bstran@care4u.vn',
      'role': 'doctor',
      'isActive': false,
      'joinDate': '2025-03-01',
    },
  ];

  // ─── Current Patient Profile ──────────────────────────────────────────────────
  static Map<String, dynamic> currentPatient = {
    'name': 'Nguyễn Thành Danh',
    'email': 'danh.nguyen@gmail.com',
    'phone': '0987654321',
    'dob': '1998-05-15',
    'gender': 'Nam',
    'address': '123 Nguyễn Huệ, Q.1, TP.HCM',
    'avatarUrl': '',
    'bloodType': 'O+',
  };

// ─── Actions ────────────────────────────────────────────────────────────────
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load appointments
    final String? appointmentsJson = prefs.getString('mock_appointments');
    if (appointmentsJson != null) {
      final List<dynamic> decoded = json.decode(appointmentsJson);
      appointments = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    
    // Load notifications
    final String? notificationsJson = prefs.getString('mock_notifications');
    if (notificationsJson != null) {
      final List<dynamic> decoded = json.decode(notificationsJson);
      notifications = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    // Load reviews
    final String? reviewsJson = prefs.getString('mock_reviews');
    if (reviewsJson != null) {
      final List<dynamic> decoded = json.decode(reviewsJson);
      reviews = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
  }

  static Future<void> _saveAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mock_appointments', json.encode(appointments));
  }

  static Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mock_notifications', json.encode(notifications));
  }

  static void addAppointment(Map<String, dynamic> appointment) {
    appointments.insert(0, appointment);
    _saveAppointments();
  }

  static void cancelAppointment(String id) {
    final index = appointments.indexWhere((app) => app['id'] == id);
    if (index != -1) {
      appointments[index]['status'] = 'cancelled';
      _saveAppointments();
    }
  }

  static void addNotification(Map<String, dynamic> notification) {
    notifications.insert(0, notification);
    _saveNotifications();
  }

  static Future<void> _saveReviews() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mock_reviews', json.encode(reviews));
  }

  static void addReview(Map<String, dynamic> review) {
    reviews.insert(0, review);
    _saveReviews();
  }
  
  static void markAllNotificationsRead() {
    for (final n in notifications) {
      n['isRead'] = true;
    }
    _saveNotifications();
  }
  
  static void removeNotification(int index) {
    if (index >= 0 && index < notifications.length) {
      notifications.removeAt(index);
      _saveNotifications();
    }
  }
}

