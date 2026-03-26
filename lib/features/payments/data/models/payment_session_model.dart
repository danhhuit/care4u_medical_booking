import '../../domain/entities/payment_session_entity.dart';

class PaymentSessionModel extends PaymentSessionEntity {
  const PaymentSessionModel({
    required super.paymentId,
    required super.provider,
    required super.status,
    required super.amount,
    super.payUrl,
    super.deeplink,
    super.qrCodeUrl,
    super.clientSecret,
    super.expiresAt,
  });

  factory PaymentSessionModel.fromJson(Map<String, dynamic> json) {
    return PaymentSessionModel(
      paymentId: json['paymentId'] ?? '',
      provider: json['provider'] ?? '',
      status: json['status'] ?? '',
      amount: json['amount'] ?? 0,
      payUrl: json['payUrl'],
      deeplink: json['deeplink'],
      qrCodeUrl: json['qrCodeUrl'],
      clientSecret: json['clientSecret'],
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
    );
  }
}