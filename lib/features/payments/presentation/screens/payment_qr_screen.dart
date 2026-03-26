import 'package:flutter/material.dart';

class PaymentQrScreen extends StatelessWidget {
  const PaymentQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quét mã thanh toán')),
      backgroundColor: const Color(0xFFF2F4F7),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 90,
                    color: Color(0xFF2F80ED),
                  ),
                  SizedBox(height: 18),
                  Text(
                    'Quét mã QR',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Đưa mã QR vào khung hình để quét',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF2F80ED),
                  style: BorderStyle.solid,
                ),
              ),
              child: const Center(
                child: Text(
                  'Vui lòng cho phép truy cập camera để quét mã QR',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
