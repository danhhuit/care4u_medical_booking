import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  int get currentDoctorId => SettingsManager.currentDoctorId;

  final Care4UApiService _api = Care4UApiService();
  late TabController _tabController;

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _appointments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _api.getAppointments();
      if (!mounted) return;

      final doctorAppointments = data.where((item) {
        final doctorId = int.tryParse('${item['doctorId']}');
        return doctorId == currentDoctorId;
      }).toList();

      setState(() {
        _appointments = doctorAppointments;
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

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return AppColors.error;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
        return 'Xác nhận';
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã huỷ';
      default:
        return 'Chờ';
    }
  }

  bool _isUpcoming(Map<String, dynamic> item) {
    final status = '${item['status'] ?? ''}'.toLowerCase();
    return status == 'pending' || status == 'confirmed' || status == 'upcoming';
  }

  List<Map<String, dynamic>> _filtered(String type) {
    if (type == 'all') return _appointments;
    if (type == 'upcoming') return _appointments.where(_isUpcoming).toList();
    if (type == 'completed') {
      return _appointments
          .where((a) => '${a['status'] ?? ''}'.toLowerCase() == 'completed')
          .toList();
    }
    return _appointments;
  }

  String _formatCreatedAt(dynamic value) {
    final raw = '${value ?? ''}';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw.isEmpty ? 'Chưa cập nhật' : raw;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildTodayHeaderBanner() {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    final todayAppts = _appointments.where((a) {
      final status = '${a['status'] ?? ''}'.toLowerCase();
      if (status == 'cancelled' || status == 'da_huy') return false;
      final dateRaw = '${a['scheduleDate'] ?? a['appointmentDate'] ?? a['date'] ?? a['createdAt'] ?? ''}';
      if (dateRaw.isEmpty) return false;
      return dateRaw.substring(0, 10) == todayStr;
    }).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2BB5A0), Color(0xFF1A7A6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.healing, color: Colors.white, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lịch khám ngày hôm nay',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tổng số bệnh nhân: ${todayAppts.length} | Phòng khám: Phòng ${100 + currentDoctorId}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(String type) {
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
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadAppointments,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final list = _filtered(type);

    if (list.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadAppointments,
        child: ListView(
          children: const [
            SizedBox(height: 180),
            Icon(Icons.event_busy, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Center(
              child: Text(
                'Không có lịch hẹn',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    final todayList = _appointments.where((a) {
      final status = '${a['status'] ?? ''}'.toLowerCase();
      if (status == 'cancelled' || status == 'da_huy') return false;
      final dateRaw = '${a['scheduleDate'] ?? a['appointmentDate'] ?? a['date'] ?? a['createdAt'] ?? ''}';
      if (dateRaw.isEmpty) return false;
      return dateRaw.substring(0, 10) == todayStr;
    }).toList();
    
    todayList.sort((x, y) {
      final tx = '${x['startTime'] ?? x['time'] ?? '00:00'}';
      final ty = '${y['startTime'] ?? y['time'] ?? '00:00'}';
      return tx.compareTo(ty);
    });

    return RefreshIndicator(
      onRefresh: _loadAppointments,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final a = list[i];
          final status = '${a['status'] ?? 'pending'}';
          final patientName =
              '${a['patientName'] ?? 'Bệnh nhân #${a['patientId']}'}';
          final specialtyName =
              '${a['specialtyName'] ?? 'Chưa có chuyên khoa'}';
          final reason = '${a['reason'] ?? 'Không có lý do khám'}';
          final appointmentNo = '${a['appointmentNo'] ?? ''}';
          final createdAt = _formatCreatedAt(a['createdAt']);

          final index = todayList.indexWhere((item) => '${item['id']}' == '${a['id']}');
          final dateRaw = '${a['scheduleDate'] ?? a['appointmentDate'] ?? a['date'] ?? a['createdAt'] ?? ''}';
          final isToday = dateRaw.startsWith(todayStr);
          final sttText = index != -1 ? 'STT: ${index + 1}' : 'STT: -';
          final roomText = 'Phòng ${100 + currentDoctorId}';

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(patientName, style: AppTextStyles.bodyDark),
                      Text(specialtyName, style: AppTextStyles.captionLight),
                      Row(
                        children: [
                          Text(
                            'Mã lịch: $appointmentNo',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                            ),
                          ),
                          if (isToday) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                sttText,
                                style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                roomText,
                                style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        'Lý do: $reason',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Text(
                        createdAt,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.12),
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text('Lịch hẹn của tôi'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.5,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadAppointments,
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Tất cả'),
              Tab(text: 'Sắp tới'),
              Tab(text: 'Hoàn thành'),
            ],
          ),
        ),
        body: Column(
          children: [
            if (!_isLoading && _errorMessage == null) _buildTodayHeaderBanner(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildList('all'),
                  _buildList('upcoming'),
                  _buildList('completed'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

