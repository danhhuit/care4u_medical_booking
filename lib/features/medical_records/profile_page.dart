import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text('Hồ sơ cá nhân', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header: Ảnh đại diện và tên
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text('Nguyễn Văn A', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('ID: BN-20260330', style: TextStyle(color: Colors.grey)),
            
            const SizedBox(height: 20),
            
            // Khối thông tin sinh hiệu
            _buildInfoCard([
              _buildRowInfo(Icons.cake, 'Ngày sinh', '01/01/1985'),
              _buildRowInfo(Icons.wc, 'Giới tính', 'Nam'),
              _buildRowInfo(Icons.bloodtype, 'Nhóm máu', 'O+', isLast: true),
            ]),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Chỉ số sức khỏe', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            _buildInfoCard([
              _buildRowInfo(Icons.monitor_weight, 'Cân nặng', '70 kg'),
              _buildRowInfo(Icons.height, 'Chiều cao', '175 cm'),
              _buildRowInfo(Icons.warning_amber, 'Dị ứng', 'Tôm, Cua', isLast: true),
            ]),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRowInfo(IconData icon, String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue, size: 22),
              const SizedBox(width: 15),
              Text(label, style: const TextStyle(color: Colors.black87)),
              const Spacer(),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 50),
      ],
    );
  }
}