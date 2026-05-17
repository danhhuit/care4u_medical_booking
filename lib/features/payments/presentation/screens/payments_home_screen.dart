import 'package:flutter/material.dart';
import '../../../../app/router/app_navigator.dart';
import '../../../../app/router/route_names.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class PaymentsHomeScreen extends StatefulWidget {
  final int walletBalance;

  const PaymentsHomeScreen({super.key, required this.walletBalance});

  @override
  State<PaymentsHomeScreen> createState() => _PaymentsHomeScreenState();
}

class _PaymentsHomeScreenState extends State<PaymentsHomeScreen> {
  bool _isBalanceVisible = true;
  bool _isHistoryVisible = true;

  final List<Map<String, dynamic>> _mockTransactions = [
    {
      'type': 'in',
      'title_key': 'top_up_bank',
      'amount': 500000,
      'date': '17/05/2026',
      'time': '10:30',
    },
    {
      'type': 'out',
      'title_key': 'pay_booking',
      'amount': 150000,
      'date': '16/05/2026',
      'time': '14:45',
    },
    {
      'type': 'in',
      'title_key': 'top_up_momo',
      'amount': 200000,
      'date': '15/05/2026',
      'time': '09:15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: SettingsManager.themeMode,
          builder: (context, mode, _) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2F80ED),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTranslations.tr('payments_title'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6A85F1), Color(0xFF7E57C2)],
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
                                      Text(
                                        AppTranslations.tr('wallet_balance'),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
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
                                  Text(
                                    _isBalanceVisible ? _formatMoney(widget.walletBalance) : '******',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      AppNavigator.pushNamed(
                                        context,
                                        RouteNames.paymentTopup,
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                    label: Text(AppTranslations.tr('top_up')),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppTranslations.tr('transaction_history'),
                                style: TextStyle(
                                  fontSize: 20, 
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
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
                                ),
                                label: Text(
                                  _isHistoryVisible 
                                      ? AppTranslations.tr('hide_history') 
                                      : AppTranslations.tr('show_history'),
                                ),
                              ),
                            ],
                          ),
                          if (_isHistoryVisible) ...[
                            const SizedBox(height: 18),
                            ..._mockTransactions.map((tx) => _TransactionTile(
                              isIncome: tx['type'] == 'in',
                              title: AppTranslations.tr(tx['title_key']),
                              amount: tx['amount'],
                              date: tx['date'],
                              time: tx['time'],
                            )).toList(),
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
      },
    );
  }
}

String _formatMoney(int value) {
  final text = value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
  return '${text}đ';
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
                    fontSize: 16,
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
