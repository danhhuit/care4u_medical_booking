import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'review_doctor_screen.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  int get currentPatientId => SettingsManager.currentPatientId;

  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _appointments = [];
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final appointments = await _api.getAppointments();
      final reviews = await _api.getReviewsByPatient(currentPatientId);

      final patientAppointments = appointments.where((a) {
        final patientId = int.tryParse('${a['patientId'] ?? 0}') ?? 0;
        final status = '${a['status'] ?? ''}'.toLowerCase();
        return patientId == currentPatientId && status != 'cancelled';
      }).toList();

      patientAppointments.sort((a, b) {
        final da =
            DateTime.tryParse('${a['createdAt'] ?? ''}') ?? DateTime(1900);
        final db =
            DateTime.tryParse('${b['createdAt'] ?? ''}') ?? DateTime(1900);
        return db.compareTo(da);
      });

      if (!mounted) return;

      setState(() {
        _appointments = patientAppointments;
        _reviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '${AppTranslations.tr('cannot_load_reviews')}: $e';
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic>? _reviewForAppointment(dynamic appointmentId) {
    final id = '$appointmentId';
    for (final review in _reviews) {
      if ('${review['appointmentId']}' == id) return review;
    }
    return null;
  }

  String _text(dynamic value, {String fallback = 'Chưa cập nhật'}) {
    final text = '${value ?? ''}'.trim();
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  String _formatDate(dynamic value) {
    final dt = DateTime.tryParse('${value ?? ''}');
    if (dt == null) return _text(value, fallback: AppTranslations.tr('not_updated'));
    final local = dt.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _openReview(Map<String, dynamic> appt) async {
    final existingReview = _reviewForAppointment(appt['id']);
    final reviewed = existingReview != null;

    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewDoctorScreen(
          patientId: currentPatientId,
          doctorId: int.tryParse('${appt['doctorId'] ?? ''}'),
          doctorName: _text(appt['doctorName'], fallback: AppTranslations.tr('doctor_label')),
          appointmentId: '${appt['id']}',
          existingReview: existingReview,
          isReadOnly: reviewed,
        ),
      ),
    );

    if (changed == true) {
      await _loadData();
    } else {
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = SettingsManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final appBarColor = isDark ? const Color(0xFF1E1E1E) : AppColors.primary;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(AppTranslations.tr('rate_doctor'), style: const TextStyle(color: Colors.white)),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh, color: Colors.white)),
        ],
      ),
      body: _buildBody(isDark, textColor),
    );
  }

  Widget _buildBody(bool isDark, Color textColor) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadData,
                child: Text(AppTranslations.tr('retry')),
              ),
            ],
          ),
        ),
      );
    }

    if (_appointments.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          children: [
            const SizedBox(height: 180),
            const Icon(Icons.rate_review_outlined, color: Colors.grey, size: 80),
            const SizedBox(height: 16),
            Center(
              child: Text(
                AppTranslations.tr('no_appt_for_review'),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _appointments.length,
        itemBuilder: (context, index) {
          final appt = _appointments[index];
          return _appointmentCard(appt, isDark, textColor);
        },
      ),
    );
  }

  Widget _appointmentCard(Map<String, dynamic> appt, bool isDark, Color textColor) {
    final existingReview = _reviewForAppointment(appt['id']);
    final hasReviewed = existingReview != null;
    final subColor = isDark ? Colors.white70 : Colors.grey.shade600;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(
                    Icons.medical_services,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _text(appt['doctorName'], fallback: AppTranslations.tr('doctor_label')),
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _text(appt['specialtyName'], fallback: AppTranslations.tr('specialties')),
                        style: TextStyle(color: subColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (hasReviewed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppTranslations.tr('reviewed'),
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(color: isDark ? Colors.white12 : const Color(0xFFEEEEEE)),
            const SizedBox(height: 8),
            _info(
              Icons.confirmation_number_outlined,
              AppTranslations.tr('appointment_code'),
              _text(appt['appointmentNo']),
              textColor,
            ),
            const SizedBox(height: 6),
            _info(
              Icons.calendar_today,
              AppTranslations.tr('time_label'),
              _formatDate(appt['createdAt']),
              textColor,
            ),
            const SizedBox(height: 6),
            _info(
              Icons.info_outline,
              AppTranslations.tr('status_label'),
              AppTranslations.tr('${appt['status']}'.toLowerCase()),
              textColor,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _openReview(appt),
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasReviewed
                      ? (isDark ? const Color(0xFF2E2E2E) : Colors.grey.shade200)
                      : AppColors.primary,
                  foregroundColor: hasReviewed ? (isDark ? Colors.white70 : Colors.black87) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(hasReviewed ? AppTranslations.tr('view_review') : AppTranslations.tr('evaluate')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(IconData icon, String label, String value, Color textColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(value, style: TextStyle(color: textColor, fontSize: 13)),
        ),
      ],
    );
  }
}
