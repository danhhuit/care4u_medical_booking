import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import '../models/appointment_status.dart';

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointmentData;
  final AppointmentStatus status;
  final VoidCallback? onRefresh;
  final VoidCallback? onReschedule;

  const AppointmentCard({
    super.key,
    required this.appointmentData,
    required this.status,
    this.onRefresh,
    this.onReschedule,
  });

  Future<void> _cancelAppointment(BuildContext context) async {
    final reasonController = TextEditingController(
      text: 'Tôi muốn hủy lịch hẹn',
    );

    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppTranslations.tr('cancel_alerts')),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Lý do hủy lịch',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Không'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx, reasonController.text.trim());
            },
            child: const Text(
              'Xác nhận hủy',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    reasonController.dispose();

    if (reason == null || reason.isEmpty) return;
    if (!context.mounted) return;

    try {
      final appointmentId = '${appointmentData['id']}';

      final result = await Care4UApiService().cancelAppointment(
        appointmentId: appointmentId,
        cancelReason: reason,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message']?.toString() ?? 'Hủy lịch hẹn thành công',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );

      onRefresh?.call();
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hủy lịch thất bại: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String _text(dynamic value) {
    if (value == null) return '';
    if ('$value' == 'null') return '';
    return '$value';
  }

  String _getDisplayDate() {
    final date = _text(appointmentData['date']);
    final scheduleDate = _text(appointmentData['scheduleDate']);
    final createdAt = _text(appointmentData['createdAt']);

    if (date.isNotEmpty) return date;

    if (scheduleDate.isNotEmpty) {
      if (scheduleDate.length >= 10) return scheduleDate.substring(0, 10);
      return scheduleDate;
    }

    if (createdAt.isNotEmpty) {
      final parsed = DateTime.tryParse(createdAt);
      if (parsed != null) {
        return '${parsed.day.toString().padLeft(2, '0')}/'
            '${parsed.month.toString().padLeft(2, '0')}/'
            '${parsed.year}';
      }
      return createdAt;
    }

    return 'Chưa có ngày';
  }

  String _getDisplayTime() {
    final time = _text(appointmentData['time']);
    final startTime = _text(appointmentData['startTime']);
    final createdAt = _text(appointmentData['createdAt']);

    if (time.isNotEmpty) return time;

    if (startTime.isNotEmpty) {
      if (startTime.length >= 5) return startTime.substring(0, 5);
      return startTime;
    }

    if (createdAt.isNotEmpty) {
      final parsed = DateTime.tryParse(createdAt);
      if (parsed != null) {
        return '${parsed.hour.toString().padLeft(2, '0')}:'
            '${parsed.minute.toString().padLeft(2, '0')}';
      }
    }

    return 'Chưa có giờ';
  }

  String _getDoctorName() {
    final title = _text(appointmentData['doctorTitle']).trim();
    final name = _text(appointmentData['doctorName']).trim().isEmpty
        ? 'Bác sĩ'
        : _text(appointmentData['doctorName']).trim();

    if (title.isEmpty || name.startsWith(title)) {
      return name;
    }

    return '$title $name';
  }

  String _getSpecialty() {
    final specialtyName = _text(appointmentData['specialtyName']);
    final specialty = _text(appointmentData['specialty']);

    if (specialtyName.isNotEmpty) return specialtyName;
    if (specialty.isNotEmpty) return specialty;

    return 'Chuyên khoa';
  }

  String _getReason() {
    return _text(appointmentData['reason']);
  }

  String _getAppointmentNo() {
    final appointmentNo = _text(appointmentData['appointmentNo']);
    final appointmentCode = _text(appointmentData['appointmentCode']);
    final code = _text(appointmentData['code']);

    if (appointmentNo.isNotEmpty) return appointmentNo;
    if (appointmentCode.isNotEmpty) return appointmentCode;
    if (code.isNotEmpty) return code;

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final reason = _getReason();
    final appointmentNo = _getAppointmentNo();

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
                  child: const Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_getDoctorName(), style: AppTextStyles.heading2),
                      const SizedBox(height: 4),
                      Text(_getSpecialty(), style: AppTextStyles.captionLight),
                      if (appointmentNo.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Mã lịch: $appointmentNo',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _buildStatusChip(context),
              ],
            ),
            if (reason.isNotEmpty) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lý do khám: $reason',
                  style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                ),
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoRow(context, Icons.calendar_today, _getDisplayDate()),
                _infoRow(context, Icons.access_time, _getDisplayTime()),
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
                      child: Text(
                        AppTranslations.tr('cancelled'),
                        style: const TextStyle(color: Colors.grey),
                      ),
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
                      onPressed: onReschedule,
                      child: Text(
                        AppTranslations.tr('reschedule'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
        Text(text, style: AppTextStyles.captionDark),
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
