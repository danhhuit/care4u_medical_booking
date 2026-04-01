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
    {
      'id': 'r1',
      'doctorId': '1',
      'doctorName': 'BS. Nguyễn Văn An',
      'patientName': 'Nguyễn Văn Hùng',
      'rating': 5,
      'comment': 'Bác sĩ rất tận tâm, giải thích rõ ràng từng bước điều trị.',
      'date': '2026-03-20',
    },
    {
      'id': 'r2',
      'doctorId': '2',
      'doctorName': 'BS. Trần Thị Bình',
      'patientName': 'Lê Thị Mai',
      'rating': 4,
      'comment': 'Bác sĩ chuyên nghiệp, khám nhanh nhưng phòng chờ đông.',
      'date': '2026-03-15',
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
}
