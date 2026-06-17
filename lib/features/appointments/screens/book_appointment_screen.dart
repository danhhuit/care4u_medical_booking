import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/services/wallet_service.dart';
import 'package:care4u_medical_booking/features/store/presentation/screens/vietqr_payment_screen.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const BookAppointmentScreen({super.key, required this.doctorData});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoadingSchedules = true;
  bool _isSubmitting = false;
  String? _scheduleError;

  List<Map<String, dynamic>> _schedules = [];
  List<String> _dates = [];

  String? _selectedDate;
  Map<String, dynamic>? _selectedSchedule;

  String get _doctorName {
    return _stringValue(
      widget.doctorData,
      ['fullName', 'name', 'doctorName'],
      fallback: AppTranslations.tr('doctor'),
    );
  }

  String get _specialty {
    return _stringValue(
      widget.doctorData,
      ['specialtyName', 'specialty'],
      fallback: AppTranslations.tr('specialties'),
    );
  }

  int get _doctorId {
    return _intValue(widget.doctorData, ['id', 'doctorId'], fallback: 0);
  }

  String get _doctorImage {
    return _stringValue(
      widget.doctorData,
      ['avatarUrl', 'imageUrl', 'image', 'avatar'],
      fallback: '',
    );
  }

  @override
  void initState() {
    super.initState();
    _loadDoctorSchedules();
  }

  String _stringValue(
    Map<String, dynamic> data,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return fallback;
  }

  int _intValue(
    Map<String, dynamic> data,
    List<String> keys, {
    int fallback = 0,
  }) {
    for (final key in keys) {
      final value = data[key];
      final parsed = int.tryParse('${value ?? ''}');
      if (parsed != null) return parsed;
    }

    return fallback;
  }

  dynamic _scheduleValue(Map<String, dynamic> schedule, List<String> keys) {
    for (final key in keys) {
      if (schedule.containsKey(key) && schedule[key] != null) {
        return schedule[key];
      }
    }

    return null;
  }

  String _scheduleDateOf(Map<String, dynamic> schedule) {
    final value = _scheduleValue(schedule, [
      'scheduleDate',
      'ScheduleDate',
      'workDate',
      'WorkDate',
    ]);

    if (value == null) return '';

    final text = value.toString();

    final parsed = DateTime.tryParse(text);
    if (parsed != null) {
      return '${parsed.year.toString().padLeft(4, '0')}-'
          '${parsed.month.toString().padLeft(2, '0')}-'
          '${parsed.day.toString().padLeft(2, '0')}';
    }

    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(text)) {
      return text;
    }

    return text;
  }

  String _startTimeOf(Map<String, dynamic> schedule) {
    final value = _scheduleValue(schedule, ['startTime', 'StartTime']);
    if (value == null) return '';

    final text = value.toString();

    if (text.length >= 5) {
      return text.substring(0, 5);
    }

    return text;
  }

  String _endTimeOf(Map<String, dynamic> schedule) {
    final value = _scheduleValue(schedule, ['endTime', 'EndTime']);
    if (value == null) return '';

    final text = value.toString();

    if (text.length >= 5) {
      return text.substring(0, 5);
    }

    return text;
  }

  int _scheduleIdOf(Map<String, dynamic> schedule) {
    final value = _scheduleValue(schedule, ['id', 'Id']);
    return int.tryParse('${value ?? ''}') ?? 0;
  }

  Future<void> _loadDoctorSchedules() async {
    if (_doctorId <= 0) {
      setState(() {
        _isLoadingSchedules = false;
        _scheduleError = 'Không xác định được bác sĩ để tải lịch làm việc';
      });
      return;
    }

    setState(() {
      _isLoadingSchedules = true;
      _scheduleError = null;
      _schedules = [];
      _dates = [];
      _selectedDate = null;
      _selectedSchedule = null;
    });

    try {
      final data = await _api.getAvailableSchedulesByDoctor(_doctorId);

      final now = DateTime.now();
      final todayDate = DateTime(now.year, now.month, now.day);
      final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final normalized = data.where((item) {
        final dateStr = _scheduleDateOf(item);
        final scheduleId = _scheduleIdOf(item);
        if (dateStr.isEmpty || scheduleId <= 0) return false;

        final date = DateTime.tryParse(dateStr);
        if (date == null) return false;

        if (dateStr == todayStr) {
          final startTimeStr = _startTimeOf(item);
          if (startTimeStr.isNotEmpty) {
            final parts = startTimeStr.split(':');
            final startHour = int.tryParse(parts[0]) ?? 0;
            final startMin = int.tryParse(parts[1]) ?? 0;
            final scheduleDateTime = DateTime(date.year, date.month, date.day, startHour, startMin);
            return scheduleDateTime.isAfter(now);
          }
        }

        return date.isAfter(todayDate) || date.isAtSameMomentAs(todayDate);
      }).toList();

      final dates = normalized.map(_scheduleDateOf).toSet().toList();
      dates.sort();

      if (!mounted) return;

      setState(() {
        _schedules = normalized;
        _dates = dates;
        _selectedDate = dates.isNotEmpty ? dates.first : null;
        _isLoadingSchedules = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _scheduleError = e.toString();
        _isLoadingSchedules = false;
      });
    }
  }

  String _formatPrice(double price) {
    final formatted = price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$formatted đ';
  }

  void _showPaymentSelection(double fee, int scheduleId, String selectedDate, String selectedTime) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thanh toán đặt lịch khám',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Số tiền cần thanh toán: ${_formatPrice(fee)}',
                  style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet, color: AppColors.primary),
                  title: const Text('Thanh toán bằng Ví Care4U'),
                  subtitle: Text('Số dư: ${_formatPrice(WalletService.instance.balance.value)}'),
                  onTap: () {
                    Navigator.pop(context);
                    _payWithWallet(fee, scheduleId, selectedDate, selectedTime);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.qr_code, color: Colors.blue),
                  title: const Text('Thanh toán bằng chuyển khoản VietQR'),
                  subtitle: const Text('Quét mã thanh toán ngân hàng'),
                  onTap: () {
                    Navigator.pop(context);
                    _payWithVietQR(fee, scheduleId, selectedDate, selectedTime);
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _payWithWallet(double fee, int scheduleId, String selectedDate, String selectedTime) async {
    final success = WalletService.instance.deductBalance(fee, title: 'Thanh toán lịch khám BS. $_doctorName');
    if (success) {
      _executeBooking(scheduleId, selectedDate, selectedTime);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Số dư ví không đủ. Vui lòng nạp thêm tiền hoặc chọn VietQR.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _payWithVietQR(double fee, int scheduleId, String selectedDate, String selectedTime) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VietQRPaymentScreen(
          amount: fee,
          onSuccess: () {
            _executeBooking(scheduleId, selectedDate, selectedTime);
          },
        ),
      ),
    );
  }

  void _executeBooking(int scheduleId, String selectedDate, String selectedTime) async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await _api.createAppointment(
        patientId: SettingsManager.currentPatientId,
        doctorId: _doctorId,
        scheduleId: scheduleId,
        reason: 'Đặt lịch khám $_specialty',
        notes: 'Ngày khám: $selectedDate, giờ khám: $selectedTime. Đặt lịch từ Flutter.',
      );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: Text(AppTranslations.tr('success')),
          content: Text(
            '${AppTranslations.tr('booking_success_msg')}\n\n'
            'Bác sĩ: $_doctorName\n'
            'Thời gian: $selectedDate | $selectedTime\n'
            'Mã lịch: ${result['appointmentNo'] ?? result['appointment_no'] ?? ''}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context, true);
              },
              child: Text(AppTranslations.tr('close')),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đặt lịch thất bại: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmBooking() async {
    final selectedSchedule = _selectedSchedule;
    if (selectedSchedule == null || _isSubmitting) return;

    final scheduleId = _scheduleIdOf(selectedSchedule);
    if (scheduleId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn khung giờ khám hợp lệ')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final selectedDate = _scheduleDateOf(selectedSchedule);
    final selectedTime =
        '${_startTimeOf(selectedSchedule)} - ${_endTimeOf(selectedSchedule)}';

    // Verify duplication
    try {
      final existingAppts = await _api.getAppointments();
      final myPatientId = SettingsManager.currentPatientId;

      final isDuplicate = existingAppts.any((app) {
        final appPatientId = int.tryParse('${app['patientId'] ?? ''}') ?? 0;
        final appScheduleId = int.tryParse('${app['scheduleId'] ?? ''}') ?? 0;
        final appStatus = '${app['status'] ?? ''}'.toLowerCase().trim();

        if (appPatientId == myPatientId && appStatus != 'cancelled' && appStatus != 'da_huy') {
          if (appScheduleId == scheduleId) {
            return true;
          }
          final appDate = '${app['scheduleDate'] ?? app['date'] ?? ''}'.substring(0, 10);
          final appTime = '${app['startTime'] ?? app['time'] ?? ''}';
          if (appDate == selectedDate && appTime.startsWith(_startTimeOf(selectedSchedule))) {
            return true;
          }
        }
        return false;
      });

      if (isDuplicate) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn đã có lịch hẹn trùng vào khung giờ này rồi!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (e) {
      debugPrint('Error checking duplicate appointment: $e');
    }

    setState(() {
      _isSubmitting = false;
    });

    final double fee = double.tryParse('${widget.doctorData['fee'] ?? widget.doctorData['consultationFee'] ?? 300000}') ?? 300000;
    _showPaymentSelection(fee, scheduleId, selectedDate, selectedTime);
  }

  String _weekdayText(String dateText) {
    final date = DateTime.tryParse(dateText);
    if (date == null) return '';

    switch (date.weekday) {
      case DateTime.monday:
        return 'T2';
      case DateTime.tuesday:
        return 'T3';
      case DateTime.wednesday:
        return 'T4';
      case DateTime.thursday:
        return 'T5';
      case DateTime.friday:
        return 'T6';
      case DateTime.saturday:
        return 'T7';
      case DateTime.sunday:
        return 'CN';
      default:
        return '';
    }
  }

  String _dayMonthText(String dateText) {
    final date = DateTime.tryParse(dateText);
    if (date == null) return dateText;

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}';
  }

  String _timeText(Map<String, dynamic> schedule) {
    final start = _startTimeOf(schedule);
    final end = _endTimeOf(schedule);

    if (start.isEmpty && end.isEmpty) return 'Chưa có giờ';
    if (end.isEmpty) return start;

    return '$start - $end';
  }

  Widget _doctorAvatar() {
    final image = _doctorImage;

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return CircleAvatar(
        radius: 35,
        backgroundColor: Colors.grey[200],
        backgroundImage: NetworkImage(image),
        onBackgroundImageError: (_, __) {
          debugPrint('Không tải được ảnh bác sĩ: $image');
        },
      );
    }

    if (image.isNotEmpty &&
        !image.contains(':\\') &&
        !image.startsWith('/')) {
      return CircleAvatar(
        radius: 35,
        backgroundColor: Colors.grey[200],
        backgroundImage: AssetImage(image),
        onBackgroundImageError: (_, __) {
          debugPrint('Không tìm thấy ảnh asset: $image');
        },
      );
    }

    return CircleAvatar(
      radius: 35,
      backgroundColor: Colors.grey[200],
      child: const Icon(Icons.person, size: 36, color: Colors.grey),
    );
  }

  Widget _buildDateList() {
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected = date == _selectedDate;

          return GestureDetector(
            onTap: _isSubmitting
                ? null
                : () {
                    setState(() {
                      _selectedDate = date;
                      _selectedSchedule = null;
                    });
                  },
            child: Container(
              width: 82,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdayText(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _dayMonthText(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeGrid() {
    final times = _schedules.where((schedule) {
      return _scheduleDateOf(schedule) == _selectedDate;
    }).toList();

    if (times.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Không có khung giờ trống trong ngày này.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: times.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final schedule = times[index];
          final isSelected =
              _selectedSchedule != null &&
              _scheduleIdOf(_selectedSchedule!) == _scheduleIdOf(schedule);

          return GestureDetector(
            onTap: _isSubmitting
                ? null
                : () {
                    setState(() {
                      _selectedSchedule = schedule;
                    });
                  },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                _timeText(schedule),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleContent() {
    if (_isLoadingSchedules) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_scheduleError != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
            const SizedBox(height: 12),
            Text(
              'Không thể tải lịch làm việc của bác sĩ:\n$_scheduleError',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadDoctorSchedules,
              icon: const Icon(Icons.refresh),
              label: const Text('Tải lại'),
            ),
          ],
        ),
      );
    }

    if (_dates.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.event_busy, size: 70, color: Colors.grey[300]),
            const SizedBox(height: 12),
            const Text(
              'Bác sĩ hiện chưa có lịch trống.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadDoctorSchedules,
              icon: const Icon(Icons.refresh),
              label: const Text('Tải lại'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppTranslations.tr('select_date'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildDateList(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            AppTranslations.tr('select_time'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildTimeGrid(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _selectedSchedule != null && !_isSubmitting;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.tr('book_appointment_title')),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _isSubmitting ? null : _loadDoctorSchedules,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDoctorSchedules,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    _doctorAvatar(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _doctorName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _specialty,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
              _buildScheduleContent(),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: canSubmit ? _confirmBooking : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    AppTranslations.tr('confirm_booking'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
