import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class ReviewDoctorScreen extends StatefulWidget {
  final int patientId;
  final int? doctorId;
  final String? doctorName;
  final String? appointmentId;
  final Map<String, dynamic>? existingReview;
  final bool isReadOnly;

  const ReviewDoctorScreen({
    super.key,
    this.patientId = 0,
    this.doctorId,
    this.doctorName,
    this.appointmentId,
    this.existingReview,
    this.isReadOnly = false,
  });

  @override
  State<ReviewDoctorScreen> createState() => _ReviewDoctorScreenState();
}

class _ReviewDoctorScreenState extends State<ReviewDoctorScreen> {
  final Care4UApiService _api = Care4UApiService();
  final TextEditingController _commentCtrl = TextEditingController();

  int _rating = 0;
  final bool _isAnonymous = false; // Always false as anonymous review function is removed.
  bool _isSaving = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    final review = widget.existingReview;
    if (review != null) {
      _rating = int.tryParse('${review['rating'] ?? 0}') ?? 0;
      _commentCtrl.text = '${review['comment'] ?? ''}';
    }
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.isReadOnly || widget.existingReview != null) return;

    final doctorId = widget.doctorId;
    final appointmentId = widget.appointmentId;

    if (doctorId == null || appointmentId == null || appointmentId.isEmpty) {
      _showError(AppTranslations.tr('missing_doctor_appt_info'));
      return;
    }

    if (_rating < 1 || _rating > 5) {
      _showError(AppTranslations.tr('review_choose_star'));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final result = await _api.createReview(
        patientId: widget.patientId > 0
          ? widget.patientId
          : SettingsManager.currentPatientId,
        doctorId: doctorId,
        appointmentId: appointmentId,
        rating: _rating,
        comment: _commentCtrl.text.trim().isEmpty
            ? null
            : _commentCtrl.text.trim(),
        isAnonymous: _isAnonymous,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result['message'] ?? AppTranslations.tr('review_success_title')}'),
          backgroundColor: AppColors.primary,
        ),
      );

      setState(() {
        _submitted = true;
        _isSaving = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showError('${AppTranslations.tr('review_failed_msg')}: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  String get _doctorName => widget.doctorName?.trim().isNotEmpty == true
      ? widget.doctorName!.trim()
      : AppTranslations.tr('doctor_label');

  @override
  Widget build(BuildContext context) {
    final isDark = SettingsManager.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final appBarColor = isDark ? const Color(0xFF1E1E1E) : AppColors.primary;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          widget.existingReview != null || widget.isReadOnly
              ? AppTranslations.tr('review_detail_title')
              : AppTranslations.tr('rate_doctor'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _submitted ? _buildSuccess(textColor) : _buildForm(isDark, textColor),
    );
  }

  Widget _buildSuccess(Color textColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 84),
            const SizedBox(height: 20),
            Text(
              AppTranslations.tr('review_submitted'),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              AppTranslations.tr('review_success_desc'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppTranslations.tr('back_to_previous')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(bool isDark, Color textColor) {
    final readOnly = widget.isReadOnly || widget.existingReview != null;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(
              Icons.medical_services,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _doctorName,
            style: AppTextStyles.heading2.copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            readOnly
                ? AppTranslations.tr('already_reviewed')
                : AppTranslations.tr('satisfaction_prompt'),
            style: AppTextStyles.captionLight.copyWith(color: subTextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _starRating(readOnly),
          const SizedBox(height: 8),
          _ratingLabel(),
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(AppTranslations.tr('comments_label'), style: AppTextStyles.captionDark.copyWith(color: textColor)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentCtrl,
            maxLines: 5,
            readOnly: readOnly,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: AppTranslations.tr('review_share_hint'),
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (widget.existingReview?['reply'] != null &&
              '${widget.existingReview?['reply']}'.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${AppTranslations.tr('doctor_reply_prefix')}: ${widget.existingReview?['reply']}',
                style: TextStyle(color: textColor),
              ),
            ),
          ],
          const SizedBox(height: 24),
          if (!readOnly)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(_isSaving ? AppTranslations.tr('saving_label') : AppTranslations.tr('review_submit')),
              ),
            ),
        ],
      ),
    );
  }

  Widget _starRating(bool readOnly) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final star = i + 1;
        return GestureDetector(
          onTap: readOnly ? null : () => setState(() => _rating = star),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 44,
              color: i < _rating ? Colors.amber : Colors.grey.shade300,
            ),
          ),
        );
      }),
    );
  }

  Widget _ratingLabel() {
    final labels = [
      '',
      AppTranslations.tr('very_bad_label'),
      AppTranslations.tr('bad_label'),
      AppTranslations.tr('normal_label'),
      AppTranslations.tr('good_label'),
      AppTranslations.tr('excellent_label'),
    ];
    return Text(
      _rating > 0 ? labels[_rating] : AppTranslations.tr('review_rating_prompt'),
      style: TextStyle(
        color: _rating > 0 ? Colors.amber.shade700 : Colors.grey,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
