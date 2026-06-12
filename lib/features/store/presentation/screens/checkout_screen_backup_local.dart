import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/core/services/cart_service.dart';
import 'package:care4u_medical_booking/core/services/wallet_service.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'wallet_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;
  int _paymentMethod = 0; // 0 = Tiền mặt (COD), 1 = Ví Care4U

  String _formatPrice(double price) {
    final formatted = price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$formatted đ';
  }

  void _processPayment() async {
    final totalAmount = CartService.instance.totalAmount + 30000;

    if (_paymentMethod == 1) { // Ví Care4U
      if (!WalletService.instance.deductBalance(totalAmount)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Số dư ví không đủ. Vui lòng nạp thêm tiền!'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'NẠP NGAY',
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
              },
            ),
          ),
        );
        return;
      }
    }

    setState(() => _isProcessing = true);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Clear cart
    CartService.instance.clearCart();
    
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text('Thanh toán thành công', textAlign: TextAlign.center),
          ],
        ),
        content: const Text(
          'Đơn hàng của bạn đã được thanh toán và đang được xử lý. Cảm ơn bạn đã sử dụng Care4U!',
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.popUntil(context, ModalRoute.withName(RouteNames.home));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Về Trang Chủ', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SettingsManager.themeMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
        final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
        final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;

        final totalAmount = CartService.instance.totalAmount;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: cardColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Thanh toán',
              style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Địa chỉ nhận hàng', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Người nhận: Nguyễn Văn A', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                const Text('SĐT: 0901234567', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                const SizedBox(height: 4),
                                const Text('123 Đường Nguyễn Huệ, Quận 1, TP.HCM', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              ],
                            ),
                          ),
                          const Icon(Icons.edit, color: Colors.blue, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Phương thức thanh toán', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    
                    // COD
                    GestureDetector(
                      onTap: () => setState(() => _paymentMethod = 0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _paymentMethod == 0 ? Colors.blue : Colors.grey.withValues(alpha: 0.3), width: _paymentMethod == 0 ? 2 : 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.money, color: Colors.green),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text('Tiền mặt khi nhận hàng (COD)', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                            ),
                            if (_paymentMethod == 0) const Icon(Icons.check_circle, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Ví Care4U
                    GestureDetector(
                      onTap: () => setState(() => _paymentMethod = 1),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _paymentMethod == 1 ? Colors.blue : Colors.grey.withValues(alpha: 0.3), width: _paymentMethod == 1 ? 2 : 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_wallet, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Ví Care4U', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                                  ValueListenableBuilder<double>(
                                    valueListenable: WalletService.instance.balance,
                                    builder: (context, balance, _) {
                                      return Text('Số dư: ${_formatPrice(balance)}', style: const TextStyle(color: Colors.grey, fontSize: 12));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (_paymentMethod == 1) const Icon(Icons.check_circle, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Chi tiết thanh toán', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tổng tiền hàng', style: TextStyle(color: Colors.grey)),
                              Text(_formatPrice(totalAmount), style: TextStyle(color: textColor)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Phí vận chuyển', style: TextStyle(color: Colors.grey)),
                              Text(_formatPrice(30000), style: TextStyle(color: textColor)),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tổng thanh toán', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                              Text(
                                _formatPrice(totalAmount + 30000),
                                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // padding for bottom button
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Xác nhận thanh toán',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
