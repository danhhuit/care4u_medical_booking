import 'package:flutter/material.dart';
import '../../domain/entities/payment_session_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentController extends ChangeNotifier {
  final PaymentRepository repository;

  PaymentController(this.repository);

  bool isLoading = false;
  int walletBalance = 0;
  List<TransactionEntity> transactions = [];
  String? errorMessage;

  Future<void> loadHomeData() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      walletBalance = await repository.getWalletBalance();
      transactions = await repository.getTransactions();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<PaymentSessionEntity?> createTopup({
    required int amount,
    required String provider,
    required String paymentMethod,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final session = await repository.createTopupPayment(
        amount: amount,
        provider: provider,
        paymentMethod: paymentMethod,
      );
      return session;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<PaymentSessionEntity?> payAppointment({
    required String appointmentId,
    required int amount,
    required String provider,
    required String paymentMethod,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      return await repository.createAppointmentPayment(
        appointmentId: appointmentId,
        amount: amount,
        provider: provider,
        paymentMethod: paymentMethod,
      );
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
