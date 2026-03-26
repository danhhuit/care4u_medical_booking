import '../../domain/entities/payment_session_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<PaymentSessionEntity> createAppointmentPayment({
    required String appointmentId,
    required int amount,
    required String provider,
    required String paymentMethod,
  }) {
    return remoteDataSource.createAppointmentPayment(
      appointmentId: appointmentId,
      amount: amount,
      provider: provider,
      paymentMethod: paymentMethod,
    );
  }

  @override
  Future<PaymentSessionEntity> createTopupPayment({
    required int amount,
    required String provider,
    required String paymentMethod,
  }) {
    return remoteDataSource.createTopupPayment(
      amount: amount,
      provider: provider,
      paymentMethod: paymentMethod,
    );
  }

  @override
  Future<PaymentSessionEntity> getPaymentStatus(String paymentId) {
    return remoteDataSource.getPaymentStatus(paymentId);
  }

  @override
  Future<List<TransactionEntity>> getTransactions() {
    return remoteDataSource.getTransactions();
  }

  @override
  Future<int> getWalletBalance() {
    return remoteDataSource.getWalletBalance();
  }
}
