import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  List<Map<String, dynamic>> _completedAppointments = [];

  @override
  void initState() {
    super.initState();
    _loadCompletedAppointments();
  }

  void _loadCompletedAppointments() {
    final appointments = MockData.appointments
        .where((a) => a['status'] == 'completed')
        .toList();
    
    // Sort by date descending
    appointments.sort((a, b) => b['date'].compareTo(a['date']));
    
    setState(() {
      _completedAppointments = appointments;
    });
  }

  String _getDoctorId(String doctorName) {
    final doc = MockData.doctors.firstWhere(
      (d) => d['name'] == doctorName,
      orElse: () => {'id': '1'},
    );
    return doc['id'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.tr('review_service')),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _completedAppointments.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rate_review_outlined, color: const Color.fromRGBO(224, 224, 224, 1), size: 80),
                    const SizedBox(height: 20),
                    Text(
                      AppTranslations.tr('no_review_needed'),
                      style: AppTextStyles.heading2.copyWith(color: isDark ? Colors.white : null),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppTranslations.tr('review_condition'),
                      style: AppTextStyles.bodyLight,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _completedAppointments.length,
              itemBuilder: (context, index) {
                final appt = _completedAppointments[index];
                return _buildAppointmentCard(appt, isDark);
              },
            ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appt, bool isDark) {
    final bool hasReviewed = MockData.reviews.any((r) => r['doctorName'] == appt['doctorName'] && r['patientName'] == MockData.currentPatient['name']);
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.medical_services, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appt['doctorName'], style: AppTextStyles.heading2.copyWith(fontSize: 16, color: textColor)),
                    const SizedBox(height: 4),
                    Text(appt['specialty'], style: AppTextStyles.captionLight.copyWith(color: subtitleColor)),
                  ],
                ),
              ),
              if (hasReviewed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppTranslations.tr('reviewed'),
                    style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          Divider(height: 24, color: isDark ? Colors.white12 : const Color(0xFFEEEEEE)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(appt['date'], style: AppTextStyles.bodyDark.copyWith(color: textColor)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(appt['time'], style: AppTextStyles.bodyDark.copyWith(color: textColor)),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.reviewDoctor,
                    arguments: {
                      'doctorId': _getDoctorId(appt['doctorName']),
                      'doctorName': appt['doctorName'],
                      'isReadOnly': hasReviewed, // Automatically triggers read-only mode if already reviewed
                    },
                  ).then((_) => _loadCompletedAppointments());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasReviewed ? (isDark ? Colors.grey.shade800 : Colors.grey.shade200) : AppColors.primary,
                  foregroundColor: hasReviewed ? textColor : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: hasReviewed ? 0 : 2,
                ),
                child: Text(hasReviewed ? AppTranslations.tr('view_review') : AppTranslations.tr('evaluate')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
