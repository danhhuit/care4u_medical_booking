import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import '../models/appointment_status.dart';

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointmentData;
  final AppointmentStatus status;
  final VoidCallback? onRefresh;

  const AppointmentCard({
    super.key,
    required this.appointmentData,
    required this.status,
    this.onRefresh,
  });

  Future<void> _cancelAppointment(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppTranslations.tr('cancel_alerts')),
        content: Text(
          '${AppTranslations.tr('cancel_alerts')} ${appointmentData['doctorName']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppTranslations.tr('cancelled'), style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppTranslations.tr('cancelled'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      final appIdx = MockData.appointments.indexWhere((a) => a['id'] == appointmentData['id']);
      if (appIdx != -1) {
        MockData.appointments[appIdx]['status'] = 'cancelled';
        
        MockData.notifications.insert(0, {
          'id': 'n_${DateTime.now().millisecondsSinceEpoch}',
          'title': AppTranslations.tr('cancel_alerts'),
          'body': 'You have cancelled your appointment with ${appointmentData['doctorName']} on ${appointmentData['date']}.',
          'type': 'cancelled',
          'isRead': false,
          'time': DateTime.now().toIso8601String(),
          'appointmentId': appointmentData['id'],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppTranslations.tr('cancel_success')),
            backgroundColor: Colors.redAccent,
          ),
        );
        onRefresh?.call();
      }
    }
  }

  Future<void> _rescheduleAppointment(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (picked != null) {
      if (!context.mounted) return;
      final appIdx = MockData.appointments.indexWhere((a) => a['id'] == appointmentData['id']);
      if (appIdx != -1) {
        final newDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
        MockData.appointments[appIdx]['date'] = picked.toIso8601String().substring(0, 10);
        
        MockData.notifications.insert(0, {
          'id': 'n_${DateTime.now().millisecondsSinceEpoch}',
          'title': AppTranslations.tr('rescheduled'),
          'body': 'Appointment with ${appointmentData['doctorName']} has been moved to $newDate.',
          'type': 'reminder',
          'isRead': false,
          'time': DateTime.now().toIso8601String(),
          'appointmentId': appointmentData['id'],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppTranslations.tr('rescheduled_to')} $newDate'),
            backgroundColor: AppColors.primary,
          ),
        );
        onRefresh?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.person, color: AppColors.primary, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointmentData['doctorName'] ?? 'Bác sĩ',
                        style: AppTextStyles.heading2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointmentData['specialty'] ?? 'Chuyên khoa',
                        style: AppTextStyles.captionLight,
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(context),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoRow(context, Icons.calendar_today, appointmentData['date']),
                _infoRow(context, Icons.access_time, appointmentData['time']),
              ],
            ),
            if (status == AppointmentStatus.upcoming) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _cancelAppointment(context),
                      child: Text(AppTranslations.tr('cancelled'), style: const TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () => _rescheduleAppointment(context),
                      child: Text(AppTranslations.tr('reschedule'), style: const TextStyle(color: Colors.white)),
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

  Widget _infoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.captionDark,
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color color;
    String text;
    switch (status) {
      case AppointmentStatus.upcoming:
        color = AppColors.primary;
        text = AppTranslations.tr('upcoming');
        break;
      case AppointmentStatus.completed:
        color = Colors.green;
        text = AppTranslations.tr('completed');
        break;
      case AppointmentStatus.cancelled:
        color = Colors.red;
        text = AppTranslations.tr('cancelled');
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}