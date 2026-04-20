import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = MockData.currentPatient;
    
    // Format date from YYYY-MM-DD to DD/MM/YYYY
    String formatDate(String iso) {
      if (iso.length < 10) return iso;
      final parts = iso.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return iso;
    }

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
             CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blueAccent,
              child: Text(
                patient['name']!.split(' ').last.substring(0, 1),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Text(patient['name'] ?? 'Bệnh nhân', 
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('ID: BN-${patient['phone']?.substring(patient['phone'].length > 4 ? patient['phone'].length - 4 : 0) ?? "0000"}', style: const TextStyle(color: Colors.grey)),
            
            const SizedBox(height: 20),
            
            // Khối thông tin sinh hiệu
            _buildInfoCard([
              _buildRowInfo(Icons.cake, 'Ngày sinh', formatDate(patient['dob'] ?? '')),
              _buildRowInfo(Icons.wc, 'Giới tính', patient['gender'] ?? 'Khác'),
              _buildRowInfo(Icons.bloodtype, 'Nhóm máu', patient['bloodType'] ?? 'O+', isLast: true),
            ]),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Chỉ số sức khỏe', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            _buildInfoCard([
              _buildRowInfo(Icons.monitor_weight, 'Cân nặng', patient['weight'] ?? '70 kg'),
              _buildRowInfo(Icons.height, 'Chiều cao', patient['height'] ?? '175 cm'),
              _buildRowInfo(Icons.warning_amber, 'Dị ứng', patient['allergies'] ?? 'Không', isLast: true),
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
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
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