import 'package:flutter/material.dart';

class PrescriptionListPage extends StatelessWidget {
  const PrescriptionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text('Đơn thuốc của tôi', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildPrescriptionCard(context);
        },
      ),
    );
  }

  Widget _buildPrescriptionCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.medication_liquid, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Đơn thuốc điều trị dạ dày', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Bác sĩ: Lê Văn B', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              const Text('Đang dùng', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ngày kê: 25/03/2026', style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
              ElevatedButton(
                onPressed: () {
                  // Chuyển sang trang chi tiết
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Chi tiết'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}