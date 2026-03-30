import 'package:flutter/material.dart';

class RevisitSchedulePage extends StatelessWidget {
  const RevisitSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Lịch tái khám', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.blue, Color(0xFF64B5F6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: const Column(
                children: [
                  Text('Hẹn gặp lại bạn vào', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('08:30 - Thứ Hai', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Ngày 15 tháng 04, 2026', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Divider(color: Colors.white30, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [Icon(Icons.location_on, color: Colors.white), Text('Phòng 302', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                      Column(children: [Icon(Icons.person, color: Colors.white), Text('BS. Lê Văn B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Align(alignment: Alignment.centerLeft, child: Text('Hướng dẫn chuẩn bị', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            const SizedBox(height: 15),
            _buildGuideStep('1', 'Mang theo đơn thuốc cũ và kết quả xét nghiệm.'),
            _buildGuideStep('2', 'Nhịn ăn sáng nếu cần làm xét nghiệm máu.'),
            _buildGuideStep('3', 'Đến sớm 15 phút để làm thủ tục check-in.'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Nhắc tôi trước 1 ngày', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideStep(String step, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 12, backgroundColor: Colors.blue.withOpacity(0.1), child: Text(step, style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold))),
          const SizedBox(width: 12),
          Expanded(child: Text(content, style: const TextStyle(color: Colors.black87, fontSize: 14))),
        ],
      ),
    );
  }
}