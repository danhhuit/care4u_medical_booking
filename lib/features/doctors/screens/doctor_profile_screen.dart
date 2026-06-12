import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctor_reviews_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  int get currentDoctorId => SettingsManager.currentDoctorId;

  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _doctor;

  @override
  void initState() {
    super.initState();
    _loadDoctorProfile();
  }

  Future<void> _loadDoctorProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _api.getObject('/Doctors/$currentDoctorId');
      if (!mounted) return;
      setState(() {
        _doctor = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Không thể tải hồ sơ bác sĩ: $e';
        _isLoading = false;
      });
    }
  }

  String _text(String key, [String fallback = 'Chưa cập nhật']) {
    final value = _doctor?[key];
    if (value == null || '$value'.trim().isEmpty) return fallback;
    return '$value';
  }

  Widget _buildLoadingOrError() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage ?? 'Có lỗi xảy ra',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadDoctorProfile,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _errorMessage != null || _doctor == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: _buildLoadingOrError(),
      );
    }

    final name = _text('fullName');
    final specialty = _text('specialtyName');
    final hospital = _text('healthCenterName');
    final experience = '${_doctor?['experienceYears'] ?? 0} năm';
    final rating =
        '${_doctor?['rating'] ?? 0} (${_doctor?['totalReviews'] ?? 0} đánh giá)';
    final license = _text('licenseNumber');
    final address = _text('healthCenterAddress');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                onPressed: _loadDoctorProfile,
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2BB5A0), Color(0xFF1A7A6E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        child: Text(
                          name.split(' ').last.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        specialty,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thông tin hành nghề', style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                  _infoCard([
                    _row(Icons.badge, 'Mã định danh', license),
                    _div(),
                    _row(Icons.local_hospital, 'Bệnh viện', hospital),
                    _div(),
                    _row(Icons.location_on, 'Địa chỉ', address),
                    _div(),
                    _row(Icons.work, 'Kinh nghiệm', experience),
                    _div(),
                    _row(Icons.star, 'Đánh giá TB', rating),
                  ]),
                  const SizedBox(height: 20),
                  Text('Liên hệ', style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                  _infoCard([
                    _row(Icons.phone, 'Điện thoại', 'Chưa cập nhật'),
                    _div(),
                    _row(Icons.email, 'Email', 'Chưa cập nhật'),
                  ]),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await SettingsManager.clearSession();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            RouteNames.login,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Đăng xuất',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DoctorReviewsScreen(doctorData: _doctor!),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.star),
                      label: const Text('Xem đánh giá của tôi'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
      ],
    ),
    child: Column(children: children),
  );

  Widget _row(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.captionLight),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyDark),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _div() => const Divider(height: 1, indent: 48);
}
