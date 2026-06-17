import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctor_reviews_screen.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

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
    final experience = '${_doctor?['experienceYears'] ?? 0} ${AppTranslations.tr('years')}';
    final rating =
        '${_doctor?['rating'] ?? 0} (${_doctor?['totalReviews'] ?? 0} ${AppTranslations.tr('reviews_count')})';
    final license = _text('licenseNumber');
    final address = _text('healthCenterAddress');

    final isDark = SettingsManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
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
                  Text(
                    AppTranslations.tr('practice_info'),
                    style: AppTextStyles.heading2.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 8),
                  _infoCard([
                    _row(Icons.badge, AppTranslations.tr('license_number'), license, textColor),
                    _div(),
                    _row(Icons.local_hospital, AppTranslations.tr('hospital_label'), hospital, textColor),
                    _div(),
                    _row(Icons.location_on, AppTranslations.tr('address_label'), address, textColor),
                    _div(),
                    _row(Icons.work, AppTranslations.tr('experience'), experience, textColor),
                    _div(),
                    _row(Icons.star, AppTranslations.tr('avg_rating'), rating, textColor),
                  ], cardColor),
                  const SizedBox(height: 20),
                  Text(
                    AppTranslations.tr('contact_label'),
                    style: AppTextStyles.heading2.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 8),
                  _infoCard([
                    _row(Icons.phone, AppTranslations.tr('phone_label_short'), AppTranslations.tr('not_updated'), textColor),
                    _div(),
                    _row(Icons.email, AppTranslations.tr('email_label'), AppTranslations.tr('not_updated'), textColor),
                  ], cardColor),
                  const SizedBox(height: 20),
                  Text(
                    AppTranslations.tr('system_settings'),
                    style: AppTextStyles.heading2.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 8),
                  _infoCard([
                    SwitchListTile(
                      secondary: const Icon(Icons.dark_mode, color: AppColors.primary),
                      title: Text(
                        AppTranslations.tr('dark_mode'),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      value: isDark,
                      activeColor: AppColors.primary,
                      onChanged: (value) async {
                        await SettingsManager.toggleTheme(value);
                        setState(() {});
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                value
                                    ? 'Đã bật chế độ tối'
                                    : 'Đã tắt chế độ tối',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ], cardColor),
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
                      label: Text(
                        AppTranslations.tr('logout'),
                        style: const TextStyle(color: Colors.red),
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
                      label: Text(AppTranslations.tr('view_my_reviews')),
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

  Widget _infoCard(List<Widget> children, Color cardColor) => Container(
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
      ],
    ),
    child: Column(children: children),
  );

  Widget _row(IconData icon, String label, String value, Color textColor) => Padding(
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
              Text(
                value,
                style: AppTextStyles.bodyDark.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _div() => const Divider(height: 1, indent: 48);
}
