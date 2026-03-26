import 'package:care4u_medical_booking/features/payments/domain/entities/transaction_entity.dart';
import '../entities/payment_session_entity.dart';

abstract class PaymentRepository {
  Future<PaymentSessionEntity> createAppointmentPayment({
    required String appointmentId,
    required int amount,
    required String provider,
    required String paymentMethod,
  });

  Future<PaymentSessionEntity> createTopupPayment({
    required int amount,
    required String provider,
    required String paymentMethod,
  });

  Future<List<TransactionEntity>> getTransactions();

  Future<PaymentSessionEntity> getPaymentStatus(String paymentId);

  Future<int> getWalletBalance();
}
