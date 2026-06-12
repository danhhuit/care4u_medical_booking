import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';

class DoctorReviewsScreen extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const DoctorReviewsScreen({super.key, required this.doctorData});

  @override
  State<DoctorReviewsScreen> createState() => _DoctorReviewsScreenState();
}

class _DoctorReviewsScreenState extends State<DoctorReviewsScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  bool _isReplying = false;
  String? _error;
  int? _selectedStar;
  String _selectedSort = 'newest';
  List<Map<String, dynamic>> _reviews = [];

  int get _doctorId => int.tryParse('${widget.doctorData['id'] ?? 1}') ?? 1;
  String get _doctorName =>
      '${widget.doctorData['fullName'] ?? widget.doctorData['name'] ?? 'Bác sĩ'}';
  String get _specialty =>
      '${widget.doctorData['specialtyName'] ?? widget.doctorData['specialty'] ?? ''}';

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _api.getReviewsByDoctor(_doctorId);
      if (!mounted) return;
      setState(() {
        _reviews = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải đánh giá: $e';
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _filteredReviews() {
    var list = List<Map<String, dynamic>>.from(_reviews);

    if (_selectedStar != null) {
      list = list
          .where(
            (r) => (int.tryParse('${r['rating'] ?? 0}') ?? 0) == _selectedStar,
          )
          .toList();
    }

    list.sort((a, b) {
      final da = DateTime.tryParse('${a['createdAt'] ?? ''}') ?? DateTime(1900);
      final db = DateTime.tryParse('${b['createdAt'] ?? ''}') ?? DateTime(1900);
      return _selectedSort == 'newest' ? db.compareTo(da) : da.compareTo(db);
    });

    return list;
  }

  double _averageRating() {
    if (_reviews.isEmpty) return 0;
    final total = _reviews.fold<int>(
      0,
      (sum, item) => sum + (int.tryParse('${item['rating'] ?? 0}') ?? 0),
    );
    return total / _reviews.length;
  }

  String _formatDateTime(dynamic value) {
    final dt = DateTime.tryParse('${value ?? ''}');
    if (dt == null) return '';
    final local = dt.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year} · ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _replyReview(Map<String, dynamic> review) async {
    final controller = TextEditingController(text: '${review['reply'] ?? ''}');

    final reply = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phản hồi đánh giá'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Nhập phản hồi của bác sĩ...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (reply == null) return;
    if (reply.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phản hồi không được để trống'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final reviewId = int.tryParse('${review['id']}');
    if (reviewId == null) return;

    setState(() => _isReplying = true);

    try {
      await _api.replyReview(reviewId: reviewId, reply: reply);
      await _loadReviews();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã phản hồi đánh giá'),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phản hồi thất bại: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isReplying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredReviews();
    final avg = _averageRating();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá của tôi'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _loadReviews, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          _header(avg),
          _filters(),
          Expanded(child: _body(filtered)),
        ],
      ),
    );
  }

  Widget _header(double avg) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: Text(
              _doctorName.isNotEmpty
                  ? _doctorName.split(' ').last.substring(0, 1)
                  : 'D',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _doctorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                if (_specialty.trim().isNotEmpty)
                  Text(
                    _specialty,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (i) => Icon(
                        i < avg.round() ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${avg.toStringAsFixed(1)} (${_reviews.length} đánh giá)',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: _selectedSort,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'newest', child: Text('Mới nhất')),
              DropdownMenuItem(value: 'oldest', child: Text('Cũ nhất')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _selectedSort = value);
            },
          ),
          DropdownButton<int?>(
            value: _selectedStar,
            underline: const SizedBox(),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Tất cả sao'),
              ),
              ...List.generate(5, (i) {
                final star = 5 - i;
                return DropdownMenuItem<int?>(
                  value: star,
                  child: Text('$star sao'),
                );
              }),
            ],
            onChanged: (value) => setState(() => _selectedStar = value),
          ),
        ],
      ),
    );
  }

  Widget _body(List<Map<String, dynamic>> filtered) {
    if (_isLoading || _isReplying)
      return const Center(child: CircularProgressIndicator());

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
                onPressed: _loadReviews,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (filtered.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadReviews,
        child: ListView(
          children: const [
            SizedBox(height: 180),
            Icon(Icons.star_border, color: Colors.grey, size: 72),
            SizedBox(height: 12),
            Center(child: Text('Chưa có đánh giá')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReviews,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _reviewCard(filtered[index]),
      ),
    );
  }

  Widget _reviewCard(Map<String, dynamic> review) {
    final rating = int.tryParse('${review['rating'] ?? 0}') ?? 0;
    final patientName = '${review['patientName'] ?? 'Ẩn danh'}';
    final comment = '${review['comment'] ?? ''}'.trim();
    final reply = '${review['reply'] ?? ''}'.trim();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: Text(
                    patientName.isNotEmpty ? patientName[0] : '?',
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _formatDateTime(review['createdAt']),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            if (comment.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(comment, style: const TextStyle(height: 1.4)),
            ],
            if (reply.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Phản hồi của bạn: $reply'),
              ),
            ],
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _replyReview(review),
                icon: const Icon(Icons.reply),
                label: Text(reply.isEmpty ? 'Phản hồi' : 'Sửa phản hồi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
