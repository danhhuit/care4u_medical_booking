import 'package:flutter/material.dart';
import '../../../core/api/care4u_api_service.dart';
// import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

String _cleanImageUrl(dynamic value) {
  final text = '${value ?? ''}'.trim();
  if (text.isEmpty || text == 'null') return '';
  return text;
}

Widget buildDoctorAvatar(Map<String, dynamic> doctor, {double size = 64}) {
  final imageUrl = _cleanImageUrl(
    doctor['avatarUrl'] ??
        doctor['avatar_url'] ??
        doctor['imageUrl'] ??
        doctor['photoUrl'],
  );

  final name = '${doctor['fullName'] ?? doctor['name'] ?? 'B'}'.trim();
  final initial = name.isNotEmpty ? name[0].toUpperCase() : 'B';

  if (imageUrl.isNotEmpty) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return CircleAvatar(
            radius: size / 2,
            child: Text(
              initial,
              style: TextStyle(
                fontSize: size * 0.35,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  return CircleAvatar(
    radius: size / 2,
    child: Text(
      initial,
      style: TextStyle(fontSize: size * 0.35, fontWeight: FontWeight.bold),
    ),
  );
}

class ApiDoctorsScreen extends StatefulWidget {
  const ApiDoctorsScreen({super.key});

  @override
  State<ApiDoctorsScreen> createState() => _ApiDoctorsScreenState();
}

class _ApiDoctorsScreenState extends State<ApiDoctorsScreen> {
  final Care4UApiService _api = Care4UApiService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> _allDoctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final doctors = await _api.getDoctors();

      setState(() {
        _allDoctors = doctors;
        _filteredDoctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải danh sách bác sĩ:\n$e';
        _isLoading = false;
      });
    }
  }

  void _searchDoctors(String keyword) {
    final query = keyword.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredDoctors = _allDoctors;
      } else {
        _filteredDoctors = _allDoctors.where((doctor) {
          final name = '${doctor['fullName'] ?? ''}'.toLowerCase();
          final specialty = '${doctor['specialtyName'] ?? ''}'.toLowerCase();
          final hospital = '${doctor['healthCenterName'] ?? ''}'.toLowerCase();

          return name.contains(query) ||
              specialty.contains(query) ||
              hospital.contains(query);
        }).toList();
      }
    });
  }

  String _formatFee(dynamic value) {
    if (value == null) return 'Chưa cập nhật';

    final number = double.tryParse(value.toString());
    if (number == null) return '$value';

    return '${number.toStringAsFixed(0)} đ';
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    final name = doctor['fullName'] ?? 'Chưa có tên';
    final title = doctor['title'] ?? '';
    final specialty = doctor['specialtyName'] ?? 'Chưa có chuyên khoa';
    final hospital = doctor['healthCenterName'] ?? 'Chưa có bệnh viện';
    final address = doctor['healthCenterAddress'] ?? '';
    final rating = doctor['rating'] ?? 0;
    final totalReviews = doctor['totalReviews'] ?? 0;
    final experience = doctor['experienceYears'] ?? 0;
    final fee = _formatFee(doctor['consultationFee']);
    final isAvailable = doctor['isAvailable'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ApiDoctorDetailScreen(doctor: doctor),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDoctorAvatar(doctor, size: 64),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title $name',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(specialty, style: const TextStyle(color: Colors.blue)),
                    const SizedBox(height: 4),
                    Text(hospital, style: const TextStyle(fontSize: 13)),
                    if (address.toString().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        address,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Chip(
                          label: Text('$experience năm KN'),
                          visualDensity: VisualDensity.compact,
                        ),
                        Chip(
                          label: Text('⭐ $rating ($totalReviews)'),
                          visualDensity: VisualDensity.compact,
                        ),
                        Chip(
                          label: Text(fee),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isAvailable
                          ? 'Đang nhận lịch khám'
                          : 'Tạm ngưng nhận lịch',
                      style: TextStyle(
                        color: isAvailable ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
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
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadDoctors,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredDoctors.isEmpty) {
      return const Center(child: Text('Không tìm thấy bác sĩ phù hợp'));
    }

    return RefreshIndicator(
      onRefresh: _loadDoctors,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredDoctors.length,
        itemBuilder: (context, index) {
          return _buildDoctorCard(_filteredDoctors[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách bác sĩ API')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _searchDoctors,
              decoration: InputDecoration(
                hintText: 'Tìm bác sĩ, chuyên khoa, bệnh viện...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _searchDoctors('');
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tổng số: ${_filteredDoctors.length} bác sĩ',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}

class ApiDoctorDetailScreen extends StatelessWidget {
  const ApiDoctorDetailScreen({super.key, required this.doctor});

  final Map<String, dynamic> doctor;

  String _formatFee(dynamic value) {
    if (value == null) return 'Chưa cập nhật';

    final number = double.tryParse(value.toString());
    if (number == null) return '$value';

    return '${number.toStringAsFixed(0)} đ';
  }

  @override
  Widget build(BuildContext context) {
    final name = doctor['fullName'] ?? 'Chưa có tên';
    final title = doctor['title'] ?? '';
    final specialty = doctor['specialtyName'] ?? 'Chưa có chuyên khoa';
    final hospital = doctor['healthCenterName'] ?? 'Chưa có bệnh viện';
    final address = doctor['healthCenterAddress'] ?? '';
    final bio = doctor['bio'] ?? 'Chưa có giới thiệu';
    final experience = doctor['experienceYears'] ?? 0;
    final rating = doctor['rating'] ?? 0;
    final fee = _formatFee(doctor['consultationFee']);

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết bác sĩ')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: buildDoctorAvatar(doctor, size: 96)),
          const SizedBox(height: 16),
          Text(
            '$title $name',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            specialty,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.blue, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_hospital),
              title: Text(hospital),
              subtitle: Text(address.toString()),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Kinh nghiệm'),
              subtitle: Text('$experience năm'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Đánh giá'),
              subtitle: Text('$rating sao'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.payments),
              title: const Text('Phí tư vấn'),
              subtitle: Text(fee),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Giới thiệu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(bio.toString()),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final reasonController = TextEditingController(
                text: 'Tư vấn sức khỏe',
              );

              final reason = await showDialog<String>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text('Đặt lịch khám'),
                    content: TextField(
                      controller: reasonController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Lý do khám',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Hủy'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                            reasonController.text.trim(),
                          );
                        },
                        child: const Text('Xác nhận'),
                      ),
                    ],
                  );
                },
              );

              reasonController.dispose();

              if (reason == null || reason.isEmpty) {
                return;
              }

              try {
                final doctorId = int.tryParse('${doctor['id']}') ?? 1;

                final result = await Care4UApiService().createAppointment(
                  patientId: SettingsManager.currentPatientId,
                  doctorId: doctorId,
                  reason: reason,
                  notes: 'Đặt lịch từ Flutter',
                );

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${result['message']} - Mã lịch: ${result['appointmentNo']}',
                    ),
                  ),
                );

                Navigator.pop(context);
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đặt lịch thất bại: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            icon: const Icon(Icons.calendar_month),
            label: const Text('Đặt lịch khám'),
          ),
        ],
      ),
    );
  }
}
