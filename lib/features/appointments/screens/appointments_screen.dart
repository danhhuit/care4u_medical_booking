import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/features/appointments/models/appointment_status.dart';
import 'package:care4u_medical_booking/features/appointments/screens/reschedule_appointment_screen.dart';
import 'package:care4u_medical_booking/features/appointments/widgets/appointment_card.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _api.getAppointments();

      if (!mounted) return;

      setState(() {
        _appointments = data.map(_normalizeAppointment).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Không thể tải lịch hẹn: $e';
        _isLoading = false;
      });
    }
  }

  AppointmentStatus _mapStatus(String status) {
    switch (status.toLowerCase().trim()) {
      case 'confirmed':
      case 'pending':
      case 'scheduled':
      case 'upcoming':
      case 'sap_toi':
        return AppointmentStatus.upcoming;

      case 'completed':
      case 'complete':
      case 'done':
      case 'hoan_thanh':
        return AppointmentStatus.completed;

      case 'cancelled':
      case 'canceled':
      case 'da_huy':
        return AppointmentStatus.cancelled;

      default:
        return AppointmentStatus.upcoming;
    }
  }

  String _text(dynamic value) {
    if (value == null) return '';
    if ('$value' == 'null') return '';
    return '$value';
  }

  String _formatDate(dynamic value) {
    final text = _text(value);
    if (text.isEmpty) return '';

    if (text.length >= 10 && RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(text)) {
      return text.substring(0, 10);
    }

    final date = DateTime.tryParse(text);
    if (date == null) return text;

    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();

    return '$year-$month-$day';
  }

  String _formatTime(dynamic value) {
    final text = _text(value);
    if (text.isEmpty) return '';

    if (RegExp(r'^\d{2}:\d{2}').hasMatch(text)) {
      return text.substring(0, 5);
    }

    final date = DateTime.tryParse(text);
    if (date == null) return text;

    final local = date.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  dynamic _firstValue(Map<String, dynamic> item, List<String> keys) {
    for (final key in keys) {
      if (item.containsKey(key) &&
          item[key] != null &&
          '${item[key]}'.isNotEmpty) {
        return item[key];
      }
    }

    final schedule = item['schedule'];
    if (schedule is Map) {
      for (final key in keys) {
        if (schedule.containsKey(key) &&
            schedule[key] != null &&
            '${schedule[key]}'.isNotEmpty) {
          return schedule[key];
        }
      }
    }

    return null;
  }

  Map<String, dynamic> _normalizeAppointment(Map<String, dynamic> item) {
    final doctorTitle = _text(item['doctorTitle']).trim();
    final doctorName = _text(item['doctorName']).trim().isEmpty
        ? 'Bác sĩ'
        : _text(item['doctorName']).trim();

    final fullDoctorName = doctorTitle.isEmpty
        ? doctorName
        : '$doctorTitle $doctorName';

    final scheduleDate = _firstValue(item, [
      'scheduleDate',
      'appointmentDate',
      'date',
    ]);

    final scheduleTime = _firstValue(item, [
      'startTime',
      'appointmentTime',
      'time',
    ]);

    return {
      ...item,
      'id': _text(item['id']),
      'appointmentNo': _text(
        item['appointmentNo'] ?? item['appointmentCode'] ?? item['code'],
      ),
      'doctorId': item['doctorId'],
      'scheduleId': item['scheduleId'],
      'doctorName': fullDoctorName,
      'patientName': _text(item['patientName']).isEmpty
          ? 'Bệnh nhân'
          : _text(item['patientName']),
      'specialty': _text(item['specialtyName']).isEmpty
          ? 'Chuyên khoa'
          : _text(item['specialtyName']),
      'hospital': _text(item['healthCenterName']).isEmpty
          ? 'Care4U Hospital'
          : _text(item['healthCenterName']),
      'date': _formatDate(scheduleDate ?? item['createdAt']),
      'time': _formatTime(scheduleTime ?? item['createdAt']),
      'status': _text(item['status']).isEmpty
          ? 'pending'
          : _text(item['status']),
      'reason': _text(item['reason']),
    };
  }

  Future<void> _refresh() async {
    await _loadAppointments();
  }

  Future<void> _openReschedule(Map<String, dynamic> appointment) async {
    final appointmentId = _text(appointment['id']);

    if (appointmentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy mã lịch hẹn')),
      );
      return;
    }

    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => RescheduleAppointmentScreen(appointment: appointment),
      ),
    );

    if (changed == true) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lịch hẹn đã được đổi thành công')),
      );

      await _loadAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: SettingsManager.themeMode,
          builder: (context, mode, _) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(AppTranslations.tr('nav_appointments')),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: _loadAppointments,
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                  bottom: TabBar(
                    tabs: [
                      Tab(text: AppTranslations.tr('upcoming')),
                      Tab(text: AppTranslations.tr('completed')),
                      Tab(text: AppTranslations.tr('cancelled')),
                    ],
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                  ),
                ),
                body: _buildBody(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 70, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadAppointments,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    return TabBarView(
      children: [
        _buildAppointmentList(AppointmentStatus.upcoming),
        _buildAppointmentList(AppointmentStatus.completed),
        _buildAppointmentList(AppointmentStatus.cancelled),
      ],
    );
  }

  Widget _buildAppointmentList(AppointmentStatus status) {
    final filteredList = _appointments.where((app) {
      return _mapStatus(_text(app['status'])) == status;
    }).toList();

    if (filteredList.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            const SizedBox(height: 160),
            Icon(Icons.event_busy, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Center(
              child: Text(
                AppTranslations.tr('no_appointments'),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final appointment = filteredList[index];

          return AppointmentCard(
            appointmentData: appointment,
            status: status,
            onRefresh: _loadAppointments,
            onReschedule: status == AppointmentStatus.upcoming
                ? () => _openReschedule(appointment)
                : null,
          );
        },
      ),
    );
  }
}
