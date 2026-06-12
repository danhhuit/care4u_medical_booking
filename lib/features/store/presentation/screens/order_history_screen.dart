import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final Care4UApiService _api = Care4UApiService();

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _api.getOrdersByPatient(1);
      if (!mounted) return;

      setState(() {
        _orders = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Không thể tải đơn hàng: $e';
        _isLoading = false;
      });
    }
  }

  String _formatPrice(dynamic value) {
    final number = double.tryParse('${value ?? 0}') ?? 0;
    final formatted = number.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$formatted đ';
  }

  Color _statusColor(dynamic status) {
    final value = '${status ?? ''}'.toLowerCase();

    if (value == 'delivered') return Colors.green;
    if (value == 'cancelled') return Colors.red;
    if (value == 'confirmed') return Colors.blue;

    return Colors.orange;
  }

  String _statusLabel(dynamic status) {
    final value = '${status ?? ''}'.toLowerCase();

    if (value == 'pending') return 'Chờ xử lý';
    if (value == 'confirmed') return 'Đã xác nhận';
    if (value == 'delivered') return 'Đã giao';
    if (value == 'cancelled') return 'Đã hủy';

    return '${status ?? 'Không rõ'}';
  }

  Future<void> _cancelOrder(Map<String, dynamic> order) async {
    final orderId = '${order['id']}';
    final orderNo = '${order['orderNo'] ?? ''}';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hủy đơn hàng'),
          content: Text('Bạn có chắc muốn hủy đơn $orderNo không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Không'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hủy đơn', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      final result = await _api.cancelOrder(
        orderId: orderId,
        cancelReason: 'Người dùng hủy đơn hàng từ Flutter',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result['message']} - $orderNo')),
      );

      await _loadOrders();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hủy đơn thất bại: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildOrderCard(Map<String, dynamic> order, bool isDark, Color cardColor, Color textColor) {
    final items = order['items'] is List ? order['items'] as List : [];
    final status = order['status'];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(child: Icon(Icons.receipt_long)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${order['orderNo'] ?? 'Đơn hàng'}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Chip(
                label: Text(
                  _statusLabel(status),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: _statusColor(status),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            'Người nhận: ${order['shippingName'] ?? ''}',
            style: TextStyle(color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            'SĐT: ${order['shippingPhone'] ?? ''}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            'Địa chỉ: ${order['shippingAddress'] ?? ''}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          ...items.take(3).map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '• ${item['productName']} x${item['quantity']} - ${_formatPrice(item['subtotal'])}',
                style: TextStyle(color: textColor),
              ),
            );
          }),
          if (items.length > 3)
            Text(
              '... và ${items.length - 3} sản phẩm khác',
              style: const TextStyle(color: Colors.grey),
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng tiền:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                _formatPrice(order['totalAmount']),
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if ('${order['status'] ?? ''}'.toLowerCase() != 'cancelled' &&
              '${order['status'] ?? ''}'.toLowerCase() != 'delivered') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _cancelOrder(order),
                icon: const Icon(Icons.cancel),
                label: const Text('Hủy đơn hàng'),
              ),
            ),
          ],
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
              'Lịch sử đơn hàng',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: _loadOrders,
                icon: Icon(Icons.refresh, color: textColor),
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  : _orders.isEmpty
                      ? const Center(child: Text('Chưa có đơn hàng nào'))
                      : RefreshIndicator(
                          onRefresh: _loadOrders,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _orders.length,
                            itemBuilder: (context, index) {
                              return _buildOrderCard(
                                _orders[index],
                                isDark,
                                cardColor,
                                textColor,
                              );
                            },
                          ),
                        ),
        );
      },
    );
  }
}
