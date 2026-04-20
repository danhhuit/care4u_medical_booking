import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text('Kết luận của Bác sĩ', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Kết quả chẩn đoán chính
          _buildMedicalResultCard(
            title: 'Chẩn đoán xác định',
            subtitle: 'Viêm dạ dày cấp tính',
            date: '15/03/2026',
            category: 'Nội khoa',
            icon: Icons.assignment_turned_in,
            color: Colors.blue,
          ),
          
          // 2. Kết quả cận lâm sàng (Xét nghiệm/Siêu âm)
          _buildMedicalResultCard(
            title: 'Siêu âm ổ bụng',
            subtitle: 'Phát hiện vùng xung huyết nhẹ',
            date: '15/03/2026',
            category: 'Cận lâm sàng',
            icon: Icons.image_search,
            color: Colors.teal,
          ),

          // 3. Đơn thuốc đi kèm
          _buildMedicalResultCard(
            title: 'Đơn thuốc số #789',
            subtitle: '4 loại thuốc - Dùng trong 7 ngày',
            date: '15/03/2026',
            category: 'Toa thuốc',
            icon: Icons.medication,
            color: Colors.orange,
          ),

          // 4. Lời dặn từ bác sĩ
          _buildMedicalResultCard(
            title: 'Lời dặn tái khám',
            subtitle: 'Kiêng đồ cay nóng, tái khám sau 1 tuần',
            date: '15/03/2026',
            category: 'Hướng dẫn',
            icon: Icons.comment_bank,
            color: Colors.purple,
            isLast: true,
          ),
          
          const SizedBox(height: 20),
          // Banner thông tin bổ sung
          _buildNoticeBanner(),
        ],
      ),
    );
  }

  Widget _buildMedicalResultCard({
    required String title,
    required String subtitle,
    required String date,
    required String category,
    required IconData icon,
    required Color color,
    bool isLast = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                  Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(height: 10),
          if (!isLast)
          const Align(
            alignment: Alignment.centerRight,
            child: Text('Chi tiết >', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBanner() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.1))
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user, color: Colors.blue, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Kết quả của bạn sẽ được tự động cập nhật từ hệ thống bệnh viện.',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey, height: 1.4),
            ),
          )
        ],
      ),
    );
  }
}