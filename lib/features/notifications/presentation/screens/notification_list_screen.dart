import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late List<Map<String, dynamic>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(MockData.notifications);
  }

  void _markAllRead() {
    MockData.markAllNotificationsRead();
    setState(() {
      _notifications = List.from(MockData.notifications);
    });
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'reminder':
        return Icons.alarm;
      case 'confirmed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'result':
        return Icons.assignment;
      default:
        return Icons.notifications;
    }
  }

  Color _colorFor(String type) {
    switch (type) {
      case 'reminder':
        return Colors.orange;
      case 'confirmed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'result':
        return Colors.blue;
      default:
        return AppColors.primary;
    }
  }

  String _timeAgo(String isoTime) {
    try {
      final dt = DateTime.parse(isoTime);
      final diff = DateTime.now().difference(dt);
      if (diff.inDays > 0) return '${diff.inDays} ${AppTranslations.tr('day_ago')}';
      if (diff.inHours > 0) return '${diff.inHours} ${AppTranslations.tr('hour_ago')}';
      return '${diff.inMinutes} ${AppTranslations.tr('min_ago')}';
    } catch (_) {
      return '';
    }
  }

  /// Map raw titles to translation keys for synchronization
  String _translateTitle(String raw, String type) {
    if (raw.contains('Nhắc lịch')) return AppTranslations.tr('reminders');
    if (raw.contains('đã xác nhận') || raw.contains('được xác nhận') || type == 'confirmed') return AppTranslations.tr('booking_confirmed');
    if (raw.contains('bị hủy') || raw.contains('đã hủy') || type == 'cancelled') return AppTranslations.tr('cancel_alerts');
    if (raw.contains('Kết quả') || type == 'result') return AppTranslations.tr('test_results');
    return raw;
  }

  /// Map raw bodies or common patterns to translated versions
  String _translateBody(String body, String type, Map<String, dynamic> n) {
      // Very simple pattern replacement for mock data bodies
      // "Bạn có lịch khám với BS. Nguyễn Văn An vào 09:00 ngày 05/04/2026."
      // We can't do full natural language translation here perfectly without a library,
      // but we can handle the main labels if they are known patterns or types.
      
      final drName = n['doctorName'] ?? 'BS. Nguyễn Văn An';
      final dateStr = n['date'] ?? n['time']?.split('T')[0] ?? '';
      
      if (type == 'reminder') {
          return 'Appointment reminder with $drName on $dateStr';
      }
      if (type == 'confirmed') {
          return 'Your appointment with $drName on $dateStr has been confirmed.';
      }
      if (type == 'cancelled') {
          return 'Your appointment with $drName on $dateStr was cancelled.';
      }
      if (type == 'result') {
          return 'Your test results are available. Click to view.';
      }
      
      return body;
  }

  void _showAppointmentSheet(Map<String, dynamic> notification) {
    final type = notification['type'] as String;
    final bool hasAppointment =
        type == 'reminder' || type == 'confirmed' || type == 'cancelled';
    if (!hasAppointment) {
      setState(() => notification['isRead'] = true);
      return;
    }

    final String? apptId = notification['appointmentId'] as String?;
    Map<String, dynamic>? appt;
    if (apptId != null) {
      try {
        appt = MockData.appointments.firstWhere((a) => a['id'] == apptId);
      } catch (_) {}
    }
    if (appt == null && MockData.appointments.isNotEmpty) {
      try {
        if (type == 'cancelled') {
          appt = MockData.appointments.firstWhere(
              (a) => a['status'] == 'cancelled',
              orElse: () => MockData.appointments.first);
        } else {
          appt = MockData.appointments.firstWhere(
              (a) => a['status'] == 'confirmed',
              orElse: () => MockData.appointments.first);
        }
      } catch (_) {
        appt = MockData.appointments.first;
      }
    }

    setState(() => notification['isRead'] = true);

    if (appt == null) return;

    final appointment = appt;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AppointmentDetailSheet(
        appointment: appointment,
        notificationType: type,
        onCancel: () {
          Navigator.pop(context);
          _cancelAppointment(notification, appointment);
        },
      ),
    );
  }

  void _cancelAppointment(
      Map<String, dynamic> notification, Map<String, dynamic> appt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppTranslations.tr('confirm_cancellation'),
            style: AppTextStyles.heading2),
        content: Text(
          '${AppTranslations.tr('cancel_alerts')}: ${appt['doctorName']} on ${appt['date']} at ${appt['time']}?',
          style: AppTextStyles.bodyLight,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppTranslations.tr('keep_appointment'),
                style: const TextStyle(color: AppColors.primary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              MockData.cancelAppointment(appt['id']);
              MockData.addNotification({
                'id': 'n${DateTime.now().millisecondsSinceEpoch}',
                'title': AppTranslations.tr('cancel_alerts'),
                'body':
                    'Cancelled appointment with ${appt['doctorName']} on ${appt['date']}.',
                'type': 'cancelled',
                'isRead': false,
                'time': DateTime.now().toIso8601String(),
                'appointmentId': appt['id'],
              });
              setState(() {
                _notifications = List.from(MockData.notifications);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Successfully cancelled.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(AppTranslations.tr('cancel_appointment'),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        _notifications.where((n) => n['isRead'] == false).length;

    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: SettingsManager.themeMode,
          builder: (context, mode, _) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          '${AppTranslations.tr('notifications_header')}${unreadCount > 0 ? ' ($unreadCount)' : ''}',
          style: AppTextStyles.heading2,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child:
                  Text(AppTranslations.tr('mark_all_read'), style: const TextStyle(color: AppColors.primary)),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(AppTranslations.tr('no_notifications'),
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final n = _notifications[index];
                final isRead = n['isRead'] as bool;
                final type = n['type'] as String;
                final hasAction = type == 'reminder' ||
                    type == 'confirmed' ||
                    type == 'cancelled';

                return Dismissible(
                  key: ValueKey('${n['id']}_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  onDismissed: (_) {
                    MockData.removeNotification(index);
                    setState(() => _notifications = List.from(MockData.notifications));
                  },
                  child: GestureDetector(
                    onTap: () => _showAppointmentSheet(n),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isRead
                            ? Colors.white
                            : AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isRead
                              ? Colors.transparent
                              : AppColors.primary.withValues(alpha: 0.2),
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: _colorFor(type).withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_iconFor(type),
                                  color: _colorFor(type), size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _translateTitle(n['title']!, type),
                                          style:
                                              AppTextStyles.bodyDark.copyWith(
                                            fontWeight: isRead
                                                ? FontWeight.w500
                                                : FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (!isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _translateBody(n['body']!, type, n),
                                    style: AppTextStyles.captionLight,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        _timeAgo(n['time']!),
                                        style: const TextStyle(
                                            fontSize: 11, color: Colors.grey),
                                      ),
                                      if (hasAction) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: _colorFor(type)
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            type == 'cancelled'
                                                ? AppTranslations.tr('cancelled')
                                                : AppTranslations.tr('view_appointment'),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: _colorFor(type),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
          },
        );
      },
    );
  }
}

class _AppointmentDetailSheet extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final String notificationType;
  final VoidCallback onCancel;

  const _AppointmentDetailSheet({
    required this.appointment,
    required this.notificationType,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isCancelled = appointment['status'] == 'cancelled' ||
        notificationType == 'cancelled';
    final isCompleted = appointment['status'] == 'completed';
    final canCancel = !isCancelled && !isCompleted;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                   color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.calendar_today, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppTranslations.tr('appointment_detail'),
                        style: AppTextStyles.heading2),
                    _StatusChip(status: appointment['status'] ?? 'confirmed'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(),

          _infoRow(Icons.person, AppTranslations.tr('doctor'),
              appointment['doctorName'] ?? '—'),
          _infoRow(Icons.medical_services_outlined, AppTranslations.tr('specialties'),
              appointment['specialty'] ?? '—'),
          _infoRow(Icons.local_hospital_outlined, AppTranslations.tr('hospital'),
              appointment['hospital'] ?? '—'),
          _infoRow(Icons.calendar_today, AppTranslations.tr('exam_date'),
              appointment['date'] ?? '—'),
          _infoRow(Icons.access_time, AppTranslations.tr('exam_time'),
              appointment['time'] ?? '—'),

          const SizedBox(height: 20),

          if (canCancel) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                    label: Text(AppTranslations.tr('cancel_appointment'),
                        style: const TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: onCancel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: Text(AppTranslations.tr('close'),
                        style: const TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child:
                    Text(AppTranslations.tr('close'), style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.bodyDark),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'confirmed':
        color = AppColors.success;
        label = AppTranslations.tr('booking_confirmed');
        break;
      case 'cancelled':
        color = AppColors.error;
        label = AppTranslations.tr('cancelled');
        break;
      case 'completed':
        color = Colors.blue;
        label = AppTranslations.tr('completed');
        break;
      default:
        color = Colors.orange;
        label = AppTranslations.tr('upcoming');
    }
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
