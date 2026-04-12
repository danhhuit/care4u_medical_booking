import 'package:flutter/material.dart';
import 'revisit_schedule_page.dart';

class PrescriptionDetailPage extends StatelessWidget {
  const PrescriptionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Chi tiết đơn thuốc', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Danh sách thuốc (4 loại)', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildMedicineItem('Paracetamol 500mg', 'Sáng 1 - Chiều 1', 'Uống sau khi ăn no'),
            _buildMedicineItem('Esomeprazol 40mg', 'Sáng 1 (trước ăn)', 'Uống trước ăn 30 phút'),
            _buildMedicineItem('Phosphalugel', 'Khi đau', 'Hòa với nước hoặc uống trực tiếp'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.withOpacity(0.2))),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Icon(Icons.warning_amber, color: Colors.orange, size: 20), SizedBox(width: 8), Text('Lưu ý của bác sĩ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange))]),
                  SizedBox(height: 8),
                  Text('Tránh ăn đồ cay nóng, không uống rượu bia trong quá trình điều trị.', style: TextStyle(fontSize: 13, color: Colors.black87)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RevisitSchedulePage()),
                  );
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('Xem lịch tái khám', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineItem(String name, String dose, String note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.vaccines, color: Colors.blue, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Liều dùng: $dose', style: const TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w500)),
                Text(note, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
