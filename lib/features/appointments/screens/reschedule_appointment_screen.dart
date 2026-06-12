import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';

class RescheduleAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const RescheduleAppointmentScreen({super.key, required this.appointment});

  @override
  State<RescheduleAppointmentScreen> createState() =>
      _RescheduleAppointmentScreenState();
}

class _RescheduleAppointmentScreenState
    extends State<RescheduleAppointmentScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = false;
  bool _isLoadingSchedules = false;
  bool _isSaving = false;

  List<Map<String, dynamic>> _doctors = [];
  List<Map<String, dynamic>> _schedules = [];

  Map<String, dynamic>? _selectedDoctor;
  Map<String, dynamic>? _selectedSchedule;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);

    try {
      final doctors = await _api.getDoctors();

      final currentDoctorId = int.tryParse(
        '${widget.appointment['doctorId'] ?? ''}',
      );

      Map<String, dynamic>? currentDoctor;

      for (final doctor in doctors) {
        final id = int.tryParse('${doctor['id'] ?? ''}');
        if (id == currentDoctorId) {
          currentDoctor = doctor;
          break;
        }
      }

      if (!mounted) return;

      setState(() {
        _doctors = doctors;
        _selectedDoctor =
            currentDoctor ?? (doctors.isNotEmpty ? doctors.first : null);
      });

      final doctorId = int.tryParse('${_selectedDoctor?['id'] ?? ''}');
      if (doctorId != null) {
        await _loadSchedulesByDoctor(doctorId);
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage('Không thể tải danh sách bác sĩ: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadSchedulesByDoctor(int doctorId) async {
    setState(() {
      _isLoadingSchedules = true;
      _schedules = [];
      _selectedSchedule = null;
    });

    try {
      final schedules = await _api.getAvailableSchedulesByDoctor(doctorId);

      if (!mounted) return;

      setState(() {
        _schedules = schedules;
        _selectedSchedule = schedules.isNotEmpty ? schedules.first : null;
      });
    } catch (e) {
      if (!mounted) return;

      _showMessage('Không thể tải lịch làm việc: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingSchedules = false);
      }
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final appointmentId = '${widget.appointment['id'] ?? ''}'.trim();
    final doctorId = int.tryParse('${_selectedDoctor?['id'] ?? ''}');
    final scheduleId = int.tryParse('${_selectedSchedule?['id'] ?? ''}');

    if (appointmentId.isEmpty) {
      _showMessage('Không tìm thấy mã lịch hẹn');
      return;
    }

    if (doctorId == null) {
      _showMessage('Vui lòng chọn bác sĩ');
      return;
    }

    if (scheduleId == null) {
      _showMessage('Vui lòng chọn ngày giờ khám');
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        final doctorName = _doctorName(_selectedDoctor!);
        final scheduleText = _scheduleText(_selectedSchedule!);

        return AlertDialog(
          title: const Text('Xác nhận đổi lịch'),
          content: Text(
            'Bạn muốn đổi lịch sang:\n\n'
            'Bác sĩ: $doctorName\n'
            'Thời gian: $scheduleText',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() => _isSaving = true);

    try {
      final result = await _api.rescheduleAppointment(
        appointmentId: appointmentId,
        doctorId: doctorId,
        scheduleId: scheduleId,
      );

      if (!mounted) return;

      final doctorName = _doctorName(_selectedDoctor!);
      final scheduleText = _scheduleText(_selectedSchedule!);

      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Đổi lịch thành công'),
          content: Text(
            '${result['message'] ?? 'Lịch hẹn đã được cập nhật.'}\n\n'
            'Bác sĩ mới: $doctorName\n'
            'Thời gian mới: $scheduleText',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đã hiểu'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _showMessage('Đổi lịch thất bại: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _doctorName(Map<String, dynamic> doctor) {
    final title = '${doctor['title'] ?? ''}'.trim();
    final name = '${doctor['fullName'] ?? doctor['name'] ?? 'Bác sĩ'}'.trim();

    if (title.isEmpty || title == 'null') return name;
    return '$title $name';
  }

  String _scheduleText(Map<String, dynamic> schedule) {
    final date = '${schedule['scheduleDate'] ?? ''}';
    final start = '${schedule['startTime'] ?? ''}';
    final end = '${schedule['endTime'] ?? ''}';

    final cleanDate = date.length >= 10 ? date.substring(0, 10) : date;
    final cleanStart = start.length >= 5 ? start.substring(0, 5) : start;
    final cleanEnd = end.length >= 5 ? end.substring(0, 5) : end;

    return '$cleanDate | $cleanStart - $cleanEnd';
  }

  String _appointmentNo() {
    return '${widget.appointment['appointmentNo'] ?? widget.appointment['appointmentCode'] ?? widget.appointment['code'] ?? widget.appointment['id'] ?? ''}';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildDoctorDropdown() {
    return DropdownButtonFormField<Map<String, dynamic>>(
      value: _selectedDoctor,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Chọn bác sĩ',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.medical_services),
      ),
      items: _doctors.map((doctor) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: doctor,
          child: Text(_doctorName(doctor)),
        );
      }).toList(),
      onChanged: _isSaving
          ? null
          : (value) async {
              setState(() {
                _selectedDoctor = value;
                _selectedSchedule = null;
                _schedules = [];
              });

              final doctorId = int.tryParse('${value?['id'] ?? ''}');
              if (doctorId != null) {
                await _loadSchedulesByDoctor(doctorId);
              }
            },
    );
  }

  Widget _buildScheduleDropdown() {
    if (_isLoadingSchedules) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_selectedDoctor == null) {
      return const Text('Vui lòng chọn bác sĩ trước');
    }

    if (_schedules.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(8),
          color: Colors.orange.withOpacity(0.08),
        ),
        child: const Text(
          'Bác sĩ này chưa có lịch trống. Vui lòng chọn bác sĩ khác hoặc tạo lịch làm việc trước.',
          style: TextStyle(color: Colors.orange),
        ),
      );
    }

    return DropdownButtonFormField<Map<String, dynamic>>(
      value: _selectedSchedule,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Chọn ngày giờ khám',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.access_time),
      ),
      items: _schedules.map((schedule) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: schedule,
          child: Text(_scheduleText(schedule)),
        );
      }).toList(),
      onChanged: _isSaving
          ? null
          : (value) {
              setState(() => _selectedSchedule = value);
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Đổi lịch hẹn'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.event_note),
                      title: Text('Mã lịch: ${_appointmentNo()}'),
                      subtitle: const Text(
                        'Chọn bác sĩ và khung giờ còn trống để đổi lịch',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildDoctorDropdown(),

                  const SizedBox(height: 16),

                  _buildScheduleDropdown(),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: _isSaving || _selectedSchedule == null
                        ? null
                        : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.save),
                    label: Text(
                      _isSaving ? 'Đang đổi lịch...' : 'Xác nhận đổi lịch',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
