import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';

class AdminAppointmentsScreen extends StatelessWidget {
  const AdminAppointmentsScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed': return AppColors.success;
      case 'completed': return Colors.blue;
      case 'cancelled': return AppColors.error;
      default: return Colors.orange;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'confirmed': return 'Xác nhận';
      case 'completed': return 'Hoàn thành';
      case 'cancelled': return 'Đã huỷ';
      default: return 'Chờ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointments = MockData.appointments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý lịch hẹn'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final a = appointments[i];
          final status = a['status'] as String;
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a['doctorName']!, style: AppTextStyles.bodyDark),
                      Text(a['specialty']!, style: AppTextStyles.captionLight),
                      Text('${a['date']} • ${a['time']}',
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(status),
                    style: TextStyle(
                      color: _statusColor(status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
