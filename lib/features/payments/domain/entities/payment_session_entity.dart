class PaymentSessionEntity {
  final String paymentId;
  final String provider;
  final String status;
  final int amount;
  final String? payUrl;
  final String? deeplink;
  final String? qrCodeUrl;
  final String? clientSecret;
  final DateTime? expiresAt;

  const PaymentSessionEntity({
    required this.paymentId,
    required this.provider,
    required this.status,
    required this.amount,
    this.payUrl,
    this.deeplink,
    this.qrCodeUrl,
    this.clientSecret,
    this.expiresAt,
  });
}
