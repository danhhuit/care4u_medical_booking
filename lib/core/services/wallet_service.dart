import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class WalletService {
  WalletService._privateConstructor();
  static final WalletService instance = WalletService._privateConstructor();

  final ValueNotifier<double> balance = ValueNotifier<double>(1500000.0);
  final ValueNotifier<List<Map<String, dynamic>>> transactions = ValueNotifier([]);

  void addBalance(double amount, {String title = 'Tiền vào (từ Ngân hàng)'}) {
    balance.value += amount;
    _addTransaction(amount, title, true);
  }

  bool deductBalance(double amount, {String title = 'Tiền ra (thanh toán đặt lịch)'}) {
    if (balance.value >= amount) {
      balance.value -= amount;
      _addTransaction(amount, title, false);
      return true;
    }
    return false;
  }

  void _addTransaction(double amount, String title, bool isIncome) {
    final now = DateTime.now();
    final newTransaction = {
      'type': isIncome ? 'in' : 'out',
      'title': title,
      'amount': amount,
      'date': DateFormat('dd/MM/yyyy').format(now),
      'time': DateFormat('HH:mm').format(now),
    };
    transactions.value = [newTransaction, ...transactions.value];
  }
}
