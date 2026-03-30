import 'package:flutter/material.dart';
import '../widgets/appointment_card.dart';
import '../models/appointment_status.dart'; 

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});
  final List<Map<String, dynamic>> _mockAppointments = const [
    {
      'id': '1',
      'doctorName': 'BS. Nguyễn Văn An',
      'specialty': 'Tim mạch',
      'doctorImage': 'assests/images/123.jpg', 
      'date': '12/10/2026',
      'time': '09:00 AM',
      'status': AppointmentStatus.upcoming,
    },
    {
      'id': '2',
      'doctorName': 'BS. Trần Thị Bình',
      'specialty': 'Nhi khoa',
      'doctorImage': 'assests/images/234.jpg',
      'date': '15/10/2026',
      'time': '14:30 PM',
      'status': AppointmentStatus.upcoming,
    },
    {
      'id': '3',
      'doctorName': 'BS. Lê Trọng Chung',
      'specialty': 'Thần kinh',
      'doctorImage': 'assests/images/345.jpg',
      'date': '01/09/2026',
      'time': '10:00 AM',
      'status': AppointmentStatus.completed,
    },
    {
      'id': '4',
      'doctorName': 'BS. Phạm Thị Dung',
      'specialty': 'Da liễu',
      'doctorImage': 'assests/images/456.jpg',
      'date': '20/08/2026',
      'time': '16:00 PM',
      'status': AppointmentStatus.cancelled,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch hẹn'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Sắp tới'),
              Tab(text: 'Hoàn thành'),
              Tab(text: 'Đã hủy'),
            ],
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            _buildAppointmentList(AppointmentStatus.upcoming),
            _buildAppointmentList(AppointmentStatus.completed),
            _buildAppointmentList(AppointmentStatus.cancelled),
          ],
        ),
      ),
    );
  }
  Widget _buildAppointmentList(AppointmentStatus status) {
    final filteredList = _mockAppointments.where((app) => app['status'] == status).toList();

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Không có lịch hẹn nào.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return AppointmentCard(
          appointmentData: filteredList[index],
          status: status,
        );
      },
    );
  }
}