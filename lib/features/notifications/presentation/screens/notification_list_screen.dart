import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/features/prescriptions/screens/prescription_detail_page.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _api.getNotificationsByPatient(
  patientId: SettingsManager.currentPatientId,
);
      if (!mounted) return;

      setState(() {
        _notifications = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Không thể tải thông báo: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllRead() async {
    try {
      await _api.markAllNotificationsAsReadByPatient(
  patientId: SettingsManager.currentPatientId,
);
      await _loadNotifications();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đánh dấu đã đọc thất bại: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _markLocalAsRead(String id) async {
    if (id.isEmpty) return;

    final index = _notifications.indexWhere((item) => '${item['id']}' == id);
    final alreadyRead = index != -1 && _notifications[index]['isRead'] == true;

    if (alreadyRead) return;

    try {
      await _api.markNotificationAsRead(id);

      if (!mounted) return;

      setState(() {
        final currentIndex =
            _notifications.indexWhere((item) => '${item['id']}' == id);

        if (currentIndex != -1) {
          _notifications[currentIndex] = {
            ..._notifications[currentIndex],
            'isRead': true,
            'readAt': DateTime.now().toIso8601String(),
          };
        }
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đánh dấu đã đọc thất bại: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleNotificationTap(Map<String, dynamic> notification) async {
    final id = '${notification['id'] ?? ''}';
    final type = '${notification['type'] ?? ''}'.toLowerCase();
    final refType =
        '${notification['refType'] ?? notification['ref_type'] ?? ''}'
            .toLowerCase();
    final refIdRaw = '${notification['refId'] ?? notification['ref_id'] ?? ''}';

    await _markLocalAsRead(id);

    if (!mounted) return;

    if (type == 'prescription_ready' || refType == 'prescription') {
      final prescriptionId = int.tryParse(refIdRaw);

      if (prescriptionId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy mã đơn thuốc')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PrescriptionDetailScreen(
            prescriptionId: prescriptionId,
          ),
        ),
      );

      return;
    }

    _showNotificationDetail(notification);
  }

  Future<void> _deleteNotification(Map<String, dynamic> notification) async {
    final id = '${notification['id']}';

    try {
      await _api.deleteNotification(notificationId: id);
      if (!mounted) return;

      setState(() {
        _notifications.removeWhere((item) => '${item['id']}' == id);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa thông báo')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xóa thông báo thất bại: $e'),
          backgroundColor: Colors.red,
        ),
      );
      await _loadNotifications();
    }
  }

  IconData _iconFor(String type) {
    switch (type.toLowerCase()) {
      case 'reminder':
      case 'appointment_reminder':
        return Icons.alarm;
      case 'confirmed':
      case 'appointment_confirmed':
        return Icons.check_circle;
      case 'cancelled':
      case 'appointment_cancelled':
        return Icons.cancel;
      case 'result':
        return Icons.assignment;
      case 'prescription_ready':
        return Icons.medication;
      case 'payment':
      case 'payment_success':
      case 'order':
      case 'order_update':
        return Icons.receipt_long;
      default:
        return Icons.notifications;
    }
  }

  Color _colorFor(String type) {
    switch (type.toLowerCase()) {
      case 'reminder':
      case 'appointment_reminder':
        return Colors.orange;
      case 'confirmed':
      case 'appointment_confirmed':
        return AppColors.success;
      case 'cancelled':
      case 'appointment_cancelled':
        return AppColors.error;
      case 'result':
        return Colors.blue;
      case 'prescription_ready':
        return Colors.green;
      case 'payment':
      case 'payment_success':
      case 'order':
      case 'order_update':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  String _timeAgo(String? isoTime) {
    if (isoTime == null || isoTime.isEmpty) return '';

    try {
      final dt = DateTime.parse(isoTime).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inDays > 0)
        return '${diff.inDays} ${AppTranslations.tr('day_ago')}';
      if (diff.inHours > 0)
        return '${diff.inHours} ${AppTranslations.tr('hour_ago')}';
      if (diff.inMinutes > 0)
        return '${diff.inMinutes} ${AppTranslations.tr('min_ago')}';
      return 'Vừa xong';
    } catch (_) {
      return '';
    }
  }

  String _titleOf(Map<String, dynamic> item) {
    return '${item['title'] ?? 'Thông báo'}';
  }

  String _bodyOf(Map<String, dynamic> item) {
    return '${item['body'] ?? ''}';
  }

  void _showNotificationDetail(Map<String, dynamic> notification) {
    final type = '${notification['type'] ?? ''}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
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
              CircleAvatar(
                radius: 28,
                backgroundColor: _colorFor(type).withValues(alpha: 0.12),
                child: Icon(_iconFor(type), color: _colorFor(type), size: 28),
              ),
              const SizedBox(height: 14),
              Text(
                _titleOf(notification),
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 8),
              Text(
                _bodyOf(notification),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLight,
              ),
              const SizedBox(height: 12),
              if (notification['refType'] != null ||
                  notification['refId'] != null)
                Text(
                  'Liên kết: ${notification['refType'] ?? ''} ${notification['refId'] ?? ''}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppTranslations.tr('close'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications
        .where((n) => n['isRead'] == false)
        .length;

    final mode = SettingsManager.themeMode.value;
    final isDark =
        mode == ThemeMode.dark ||
        (mode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          '${AppTranslations.tr('notifications_header')}${unreadCount > 0 ? ' ($unreadCount)' : ''}',
          style: AppTextStyles.heading2.copyWith(color: textColor),
        ),
        centerTitle: true,
        backgroundColor: cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Làm mới',
            onPressed: _loadNotifications,
            icon: Icon(Icons.refresh, color: textColor),
          ),
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                AppTranslations.tr('mark_all_read'),
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: _buildBody(cardColor, textColor, isDark),
    );
  }

  Widget _buildBody(Color cardColor, Color textColor, bool isDark) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadNotifications,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadNotifications,
        child: ListView(
          children: [
            const SizedBox(height: 180),
            const Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                AppTranslations.tr('no_notifications'),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = _notifications[index];
          final isRead = item['isRead'] == true;
          final type = '${item['type'] ?? ''}';

          return Dismissible(
            key: ValueKey('${item['id']}_$index'),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              await _deleteNotification(item);
              return false;
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.delete, color: Colors.red),
            ),
            child: GestureDetector(
              onTap: () => _handleNotificationTap(item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isRead
                      ? cardColor
                      : AppColors.primary.withValues(
                          alpha: isDark ? 0.2 : 0.06,
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isRead
                        ? Colors.transparent
                        : AppColors.primary.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    if (!isDark)
                      const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
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
                        child: Icon(
                          _iconFor(type),
                          color: _colorFor(type),
                          size: 22,
                        ),
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
                                    _titleOf(item),
                                    style: AppTextStyles.bodyDark.copyWith(
                                      fontWeight: isRead
                                          ? FontWeight.w500
                                          : FontWeight.bold,
                                      color: textColor,
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
                              _bodyOf(item),
                              style: AppTextStyles.captionLight,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _timeAgo(
                                '${item['createdAt'] ?? item['time'] ?? ''}',
                              ),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
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
  }
}
