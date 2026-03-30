import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9), 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Lịch sử khám bệnh',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Phần 1: Lịch hẹn gần nhất ---
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text(
                'Lịch hẹn gần nhất',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 60, color: Colors.redAccent),
                        SizedBox(height: 10),
                        Text(
                          'Hiện tại bạn chưa có lịch hẹn nào.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Đặt lịch khám mới',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // --- Phần 2: Danh sách lịch sử khám  ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 25, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lịch sử khám',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text('Xem tất cả', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            
           
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.description_outlined, size: 80, color: Colors.blueGrey),
                    SizedBox(height: 15),
                    Text(
                      'Bạn chưa có lịch sử khám nào',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Các hoạt động khám bệnh của bạn sẽ hiển thị tại đây sau khi bạn hoàn thành các lượt khám.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Phần 3: Các nút chức năng dưới cùng ---
            const SizedBox(height: 10),
            _buildActionTile('Bạn chưa có Bác sĩ riêng?', 'Tìm BS ngay'),
            _buildActionTile('Bạn muốn mua thuốc?', 'Đặt mua ngay'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget tạo các dòng hỏi đáp dưới cùng
  Widget _buildActionTile(String title, String actionText) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            actionText,
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}