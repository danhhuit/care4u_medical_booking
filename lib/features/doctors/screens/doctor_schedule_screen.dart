import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  final Care4UApiService _api = Care4UApiService();

  int get _currentDoctorId => SettingsManager.currentDoctorId;

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _api.getDoctorSchedulesByDoctor(_currentDoctorId);
      if (!mounted) return;

      setState(() {
        _schedules = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Không thể tải lịch làm việc: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _openAddSchedulePage() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            _AddDoctorSchedulePage(doctorId: _currentDoctorId),
      ),
    );

    if (!mounted) return;

    if (created == true) {
      await _loadSchedules();
    }
  }

  Future<void> _toggleAvailability(Map<String, dynamic> schedule) async {
    final id = _toInt(schedule['id']);
    final current = schedule['isAvailable'] == true;

    if (id == null) return;

    try {
      await _api.updateDoctorSchedule(id: id, isAvailable: !current);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(!current ? 'Đã bật lịch khám' : 'Đã tắt lịch khám'),
          backgroundColor: AppColors.primary,
        ),
      );

      await _loadSchedules();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cập nhật thất bại: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteSchedule(Map<String, dynamic> schedule) async {
    final id = _toInt(schedule['id']);
    if (id == null) return;

    try {
      await _api.deleteDoctorSchedule(id);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa lịch làm việc thành công'),
          backgroundColor: AppColors.primary,
        ),
      );

      await _loadSchedules();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xóa lịch thất bại: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Lịch làm việc'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: _loadSchedules,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddSchedulePage,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm lịch', style: TextStyle(color: Colors.white)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 56, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadSchedules,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_schedules.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.event_busy, size: 64, color: Colors.grey),
              const SizedBox(height: 12),
              const Text(
                'Chưa có lịch làm việc',
                style: AppTextStyles.bodyLight,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _openAddSchedulePage,
                icon: const Icon(Icons.add),
                label: const Text('Thêm lịch đầu tiên'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSchedules,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _schedules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _schedules[index];
          return _scheduleCard(item);
        },
      ),
    );
  }

  Widget _scheduleCard(Map<String, dynamic> item) {
    final scheduleDate = '${item['scheduleDate'] ?? ''}';
    final startTime = _shortTime('${item['startTime'] ?? ''}');
    final endTime = _shortTime('${item['endTime'] ?? ''}');
    final isAvailable = item['isAvailable'] == true;
    final bookedCount = _toInt(item['bookedCount']) ?? 0;
    final maxPatients = _toInt(item['maxPatients']) ?? 1;
    final slotDuration = _toInt(item['slotDuration']) ?? 30;
    final note = '${item['note'] ?? ''}';

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event_available,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDateForDisplay(scheduleDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$startTime - $endTime',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                _statusChip(isAvailable),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'toggle') {
                      _toggleAvailability(item);
                    } else if (value == 'delete') {
                      _deleteSchedule(item);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'toggle',
                      child: Text(isAvailable ? 'Tắt lịch' : 'Bật lịch'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Xóa lịch'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _infoBox(
                    icon: Icons.people_alt_outlined,
                    label: 'Đã đặt',
                    value: '$bookedCount/$maxPatients',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _infoBox(
                    icon: Icons.timer_outlined,
                    label: 'Thời gian',
                    value: '$slotDuration phút',
                  ),
                ),
              ],
            ),
            if (note.isNotEmpty) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ghi chú: $note',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusChip(bool isAvailable) {
    final color = isAvailable ? AppColors.success : Colors.grey;
    final label = isAvailable ? 'Đang mở' : 'Đã tắt';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _infoBox({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F7F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDateForDisplay(String value) {
    if (value.length < 10) return value;
    final parts = value.substring(0, 10).split('-');
    if (parts.length != 3) return value;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  static String _shortTime(String value) {
    if (value.length >= 5) return value.substring(0, 5);
    return value;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }
}

class _AddDoctorSchedulePage extends StatefulWidget {
  final int doctorId;

  const _AddDoctorSchedulePage({required this.doctorId});

  @override
  State<_AddDoctorSchedulePage> createState() => _AddDoctorSchedulePageState();
}

class _AddDoctorSchedulePageState extends State<_AddDoctorSchedulePage> {
  final Care4UApiService _api = Care4UApiService();

  late final TextEditingController _dateController;
  final TextEditingController _startTimeController = TextEditingController(
    text: '08:00',
  );
  final TextEditingController _endTimeController = TextEditingController(
    text: '08:30',
  );
  final TextEditingController _maxPatientsController = TextEditingController(
    text: '1',
  );
  final TextEditingController _slotController = TextEditingController(
    text: '30',
  );
  final TextEditingController _noteController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _dateController = TextEditingController(text: _formatDateForApi(tomorrow));
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _maxPatientsController.dispose();
    _slotController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final date = _dateController.text.trim();
    final start = _startTimeController.text.trim();
    final end = _endTimeController.text.trim();
    final maxPatients = int.tryParse(_maxPatientsController.text.trim()) ?? 1;
    final slotDuration = int.tryParse(_slotController.text.trim()) ?? 30;
    final note = _noteController.text.trim();

    if (!_isValidDate(date)) {
      _showError('Ngày khám phải đúng định dạng YYYY-MM-DD');
      return;
    }

    final parsedDate = DateTime.tryParse(date);
    if (parsedDate != null) {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final compareDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      if (compareDate.isBefore(todayDate)) {
        _showError('Không thể thêm lịch làm việc trong quá khứ');
        return;
      }
    }

    if (!_isValidTime(start) || !_isValidTime(end)) {
      _showError('Giờ phải đúng định dạng HH:mm, ví dụ 08:00');
      return;
    }

    if (!_isEndAfterStart(start, end)) {
      _showError('Giờ kết thúc phải sau giờ bắt đầu');
      return;
    }

    if (maxPatients <= 0 || slotDuration <= 0) {
      _showError('Số bệnh nhân và thời lượng ca phải lớn hơn 0');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final result = await _api.createDoctorSchedule(
        doctorId: widget.doctorId,
        scheduleDate: _dateController.text.trim(),
        startTime: _normalizeTime(_startTimeController.text.trim()),
        endTime: _normalizeTime(_endTimeController.text.trim()),
        maxPatients: maxPatients,
        slotDuration: slotDuration,
        note: note,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${result['message'] ?? 'Tạo lịch làm việc thành công'}',
          ),
          backgroundColor: AppColors.primary,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showError('Tạo lịch thất bại: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Thêm lịch làm việc'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _field(
              controller: _dateController,
              label: 'Ngày khám',
              hint: '2026-06-08',
              icon: Icons.calendar_today,
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 12),
            _field(
              controller: _startTimeController,
              label: 'Giờ bắt đầu',
              hint: '08:00',
              icon: Icons.access_time,
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 12),
            _field(
              controller: _endTimeController,
              label: 'Giờ kết thúc',
              hint: '08:30',
              icon: Icons.timer_outlined,
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 12),
            _field(
              controller: _maxPatientsController,
              label: 'Số bệnh nhân tối đa',
              hint: '1',
              icon: Icons.people_alt_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _field(
              controller: _slotController,
              label: 'Thời lượng mỗi ca/phút',
              hint: '30',
              icon: Icons.timelapse,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _field(
              controller: _noteController,
              label: 'Ghi chú',
              hint: 'Ca khám buổi sáng',
              icon: Icons.note_alt_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Đang lưu...' : 'Lưu lịch làm việc'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static bool _isValidDate(String value) {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(value)) return false;
    return DateTime.tryParse(value) != null;
  }

  static bool _isValidTime(String value) {
    final match = RegExp(r'^(\d{2}):(\d{2})$').firstMatch(value);
    if (match == null) return false;
    final hour = int.tryParse(match.group(1) ?? '');
    final minute = int.tryParse(match.group(2) ?? '');
    if (hour == null || minute == null) return false;
    return hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59;
  }

  static bool _isEndAfterStart(String start, String end) {
    final s = start.split(':').map(int.parse).toList();
    final e = end.split(':').map(int.parse).toList();
    final startMinutes = s[0] * 60 + s[1];
    final endMinutes = e[0] * 60 + e[1];
    return endMinutes > startMinutes;
  }

  static String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _normalizeTime(String value) {
    final text = value.trim();

    if (RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(text)) {
      return text;
    }

    if (RegExp(r'^\d{2}:\d{2}$').hasMatch(text)) {
      return '$text:00';
    }

    return text;
  }
}

