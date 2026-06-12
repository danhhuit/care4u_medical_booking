import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';

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
  bool _isAnonymous = false;
  bool _isSaving = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    final review = widget.existingReview;
    if (review != null) {
      _rating = int.tryParse('${review['rating'] ?? 0}') ?? 0;
      _commentCtrl.text = '${review['comment'] ?? ''}';
      _isAnonymous = review['isAnonymous'] == true;
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
      _showError('Thiếu thông tin bác sĩ hoặc lịch hẹn để gửi đánh giá');
      return;
    }

    if (_rating < 1 || _rating > 5) {
      _showError('Vui lòng chọn số sao từ 1 đến 5');
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
          content: Text('${result['message'] ?? 'Gửi đánh giá thành công'}'),
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
      _showError('Gửi đánh giá thất bại: $e');
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
      : 'Bác sĩ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingReview != null || widget.isReadOnly
              ? 'Chi tiết đánh giá'
              : 'Đánh giá bác sĩ',
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _submitted ? _buildSuccess() : _buildForm(),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 84),
            const SizedBox(height: 20),
            const Text(
              'Đánh giá đã được gửi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Cảm ơn bạn đã gửi phản hồi. Đánh giá của bạn sẽ giúp Care4U cải thiện chất lượng dịch vụ.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.4),
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
                child: const Text('Quay lại'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    final readOnly = widget.isReadOnly || widget.existingReview != null;

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
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            readOnly
                ? 'Bạn đã đánh giá lịch hẹn này'
                : 'Bạn hài lòng với buổi khám như thế nào?',
            style: AppTextStyles.captionLight,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _starRating(readOnly),
          const SizedBox(height: 8),
          _ratingLabel(),
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Nhận xét', style: AppTextStyles.captionDark),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentCtrl,
            maxLines: 5,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: 'Chia sẻ trải nghiệm khám bệnh của bạn...',
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _isAnonymous,
            onChanged: readOnly
                ? null
                : (value) => setState(() => _isAnonymous = value),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            title: const Text('Đánh giá ẩn danh'),
            subtitle: const Text('Tên của bạn sẽ hiển thị là "Ẩn danh"'),
          ),
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
                'Phản hồi của bác sĩ: ${widget.existingReview?['reply']}',
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
                label: Text(_isSaving ? 'Đang gửi...' : 'Gửi đánh giá'),
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
    const labels = ['', 'Rất tệ', 'Tệ', 'Bình thường', 'Tốt', 'Xuất sắc'];
    return Text(
      _rating > 0 ? labels[_rating] : 'Chọn số sao',
      style: TextStyle(
        color: _rating > 0 ? Colors.amber.shade700 : Colors.grey,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

