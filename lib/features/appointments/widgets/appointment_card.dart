import 'package:flutter/material.dart';

enum AppointmentStatus { upcoming, completed, cancelled }
class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointmentData;
  final AppointmentStatus status;
  const AppointmentCard({
    super.key,
    required this.appointmentData,
    required this.status,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                    appointmentData['doctorImage'] ?? 'assets/images/default_doctor.jpg',
                  ),
                  onBackgroundImageError: (_, __) {
                    debugPrint('Lỗi tải ảnh asset: ${appointmentData['doctorImage']}');
                  },
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointmentData['doctorName'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointmentData['specialty'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      appointmentData['date'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      appointmentData['time'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            if (status == AppointmentStatus.upcoming) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[800],
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      onPressed: () {
                      },
                      child: const Text('Hủy lịch'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                      },
                      child: const Text('Đổi lịch'),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
  Widget _buildStatusChip() {
    Color color;
    String text;
    switch (status) {
      case AppointmentStatus.upcoming:
        color = Colors.blue;
        text = 'Sắp tới';
        break;
      case AppointmentStatus.completed:
        color = Colors.green;
        text = 'Hoàn thành';
        break;
      case AppointmentStatus.cancelled:
        color = Colors.red;
        text = 'Đã hủy';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}