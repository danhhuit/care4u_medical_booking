import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';

class ReviewDoctorScreen extends StatefulWidget {
  final String? doctorId;
  final String? doctorName;

  const ReviewDoctorScreen({
    super.key,
    this.doctorId,
    this.doctorName,
  });

  @override
  State<ReviewDoctorScreen> createState() => _ReviewDoctorScreenState();
}

class _ReviewDoctorScreenState extends State<ReviewDoctorScreen> {
  int _rating = 0;
  final TextEditingController _commentCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn số sao đánh giá!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    final doctorName = widget.doctorName ??
        (MockData.doctors.isNotEmpty ? MockData.doctors[0]['name'] as String : 'Bác sĩ');

    MockData.reviews.insert(0, {
      'id': 'r${DateTime.now().millisecondsSinceEpoch}',
      'doctorId': widget.doctorId ?? '1',
      'doctorName': doctorName,
      'patientName': MockData.currentPatient['name'],
      'rating': _rating,
      'comment': _commentCtrl.text.trim(),
      'date': DateTime.now().toIso8601String().substring(0, 10),
    });

    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final doctorName = widget.doctorName ??
        (MockData.doctors.isNotEmpty ? MockData.doctors[0]['name'] as String : 'Bác sĩ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá bác sĩ'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _submitted ? _buildSuccess() : _buildForm(doctorName),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Cảm ơn bạn đã đánh giá!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Đánh giá của bạn giúp các bệnh nhân khác tìm được bác sĩ phù hợp.',
              style: AppTextStyles.bodyLight,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Về trang trước', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(String doctorName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(Icons.person, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(doctorName, style: AppTextStyles.heading2, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Đánh giá trải nghiệm của bạn', style: AppTextStyles.captionLight),
          const SizedBox(height: 28),
          _buildStarRating(),
          const SizedBox(height: 8),
          _buildRatingLabel(),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Nhận xét', style: AppTextStyles.captionDark),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentCtrl,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Chia sẻ trải nghiệm của bạn về bác sĩ này...',
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildExistingReviews(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Gửi đánh giá',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return GestureDetector(
          onTap: () => setState(() => _rating = i + 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 6),
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

  Widget _buildRatingLabel() {
    const labels = ['', 'Rất tệ', 'Tệ', 'Bình thường', 'Tốt', 'Xuất sắc'];
    return Text(
      _rating > 0 ? labels[_rating] : 'Chạm để đánh giá',
      style: TextStyle(
        color: _rating > 0 ? Colors.amber.shade700 : Colors.grey,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );
  }

  Widget _buildExistingReviews() {
    final reviews = MockData.reviews.take(2).toList();
    if (reviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Đánh giá gần đây', style: AppTextStyles.heading2),
        const SizedBox(height: 10),
        ...reviews.map((r) => _reviewCard(r)),
      ],
    );
  }

  Widget _reviewCard(Map<String, dynamic> r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(r['patientName']!, style: AppTextStyles.bodyDark),
          const Spacer(),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < (r['rating'] as int) ? Icons.star : Icons.star_outline,
                size: 14,
                color: Colors.amber,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 4),
        Text(r['comment']!, style: AppTextStyles.captionLight),
        const SizedBox(height: 4),
        Text(r['date']!,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ]),
    );
  }
}
