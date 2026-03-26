import 'package:dio/dio.dart';
import '../../../../app/constants/api_constants.dart';
import '../models/payment_session_model.dart';
import '../models/transaction_model.dart';

class PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSource(this.dio);

  Future<int> getWalletBalance() async {
    final response = await dio.get(ApiConstants.wallet);
    return response.data['data']['balance'] ?? 0;
  }

  Future<PaymentSessionModel> createAppointmentPayment({
    required String appointmentId,
    required int amount,
    required String provider,
    required String paymentMethod,
  }) async {
    final response = await dio.post(
      ApiConstants.createPayment,
      data: {
        'appointmentId': appointmentId,
        'amount': amount,
        'currency': 'VND',
        'provider': provider,
        'paymentMethod': paymentMethod,
      },
    );

    return PaymentSessionModel.fromJson(response.data['data']);
  }

  Future<PaymentSessionModel> createTopupPayment({
    required int amount,
    required String provider,
    required String paymentMethod,
  }) async {
    final response = await dio.post(
      ApiConstants.topupCreate,
      data: {
        'amount': amount,
        'currency': 'VND',
        'provider': provider,
        'paymentMethod': paymentMethod,
      },
    );

    return PaymentSessionModel.fromJson(response.data['data']);
  }

  Future<PaymentSessionModel> getPaymentStatus(String paymentId) async {
    final response = await dio.get('/payments/$paymentId/status');
    return PaymentSessionModel.fromJson(response.data['data']);
  }

  Future<List<TransactionModel>> getTransactions() async {
    final response = await dio.get(ApiConstants.transactionHistory);
    final List items = response.data['data'] ?? [];
    return items.map((e) => TransactionModel.fromJson(e)).toList();
  }
}
