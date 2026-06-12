import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/core/services/wallet_service.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'vietqr_payment_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isBalanceVisible = true;
  bool _isHistoryVisible = true;

  String _formatMoney(int value) {
    final text = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return '${text}đ';
  }

  void _showDepositDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Nạp tiền vào ví', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Số tiền cần nạp (VNĐ)',
              hintText: 'Ví dụ: 500000',
              prefixIcon: const Icon(Icons.account_balance_wallet, color: Colors.blue),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text) ?? 0;
                if (amount >= 1000) { // Changed to 1000
                  Navigator.pop(dialogContext); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VietQRPaymentScreen(
                        amount: amount,
                        onSuccess: () {
                          WalletService.instance.addBalance(amount);
                          _amountController.clear();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Nạp tiền thành công!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                            );
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Số tiền nạp tối thiểu là 1.000đ'), backgroundColor: Colors.red),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Tiếp tục', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
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
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Ví của tôi',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF267D6F), Color(0xFF144D44)],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 12,
                              color: Colors.black26,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.account_balance_wallet, color: Colors.white70, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Số dư khả dụng',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isBalanceVisible = !_isBalanceVisible;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ValueListenableBuilder<double>(
                              valueListenable: WalletService.instance.balance,
                              builder: (context, balance, _) {
                                return Text(
                                  _isBalanceVisible ? _formatMoney(balance.toInt()) : '******',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _showDepositDialog,
                              icon: const Icon(Icons.add, color: Color(0xFF144D44)),
                              label: const Text('Nạp tiền vào ví', style: TextStyle(color: Color(0xFF144D44), fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lịch sử giao dịch',
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _isHistoryVisible = !_isHistoryVisible;
                              });
                            },
                            icon: Icon(
                              _isHistoryVisible ? Icons.visibility_off : Icons.visibility,
                              size: 18,
                              color: Colors.grey,
                            ),
                            label: Text(
                              _isHistoryVisible ? 'Ẩn lịch sử' : 'Hiện lịch sử',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      if (_isHistoryVisible) ...[
                        const SizedBox(height: 16),
                        ValueListenableBuilder<List<Map<String, dynamic>>>(
                          valueListenable: WalletService.instance.transactions,
                          builder: (context, transactions, _) {
                            if (transactions.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 40),
                                  child: Column(
                                    children: [
                                      Icon(Icons.history, size: 64, color: Colors.grey[400]),
                                      const SizedBox(height: 16),
                                      Text('Chưa có giao dịch nào', style: TextStyle(color: Colors.grey[500])),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            return Column(
                              children: transactions.map((tx) => _TransactionTile(
                                isIncome: tx['type'] == 'in',
                                title: tx['title'],
                                amount: (tx['amount'] as num).toInt(),
                                date: tx['date'],
                                time: tx['time'],
                              )).toList(),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final bool isIncome;
  final String title;
  final int amount;
  final String date;
  final String time;

  const _TransactionTile({
    required this.isIncome,
    required this.title,
    required this.amount,
    required this.date,
    required this.time,
  });

  String _formatMoney(int value) {
    final text = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return '${text}đ';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black12, 
            blurRadius: 4
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  '$time - $date', 
                  style: const TextStyle(color: Colors.grey, fontSize: 13)
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}${_formatMoney(amount)}',
            style: TextStyle(
              color: isIncome ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
