import 'package:flutter/material.dart';
import '../../../../app/router/app_navigator.dart';
import '../../../../app/router/route_names.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';

class PaymentsHomeScreen extends StatelessWidget {
  final int walletBalance;

  const PaymentsHomeScreen({super.key, required this.walletBalance});

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
                                  Text(
                                    AppTranslations.tr('wallet_balance'),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _formatMoney(walletBalance),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 10,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          AppNavigator.pushNamed(
                                            context,
                                            RouteNames.paymentTopup,
                                          );
                                        },
                                        icon: const Icon(Icons.add),
                                        label: Text(AppTranslations.tr('top_up')),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          AppNavigator.pushNamed(
                                            context,
                                            RouteNames.paymentQr,
                                          );
                                        },
                                        icon: const Icon(Icons.qr_code_scanner),
                                        label: Text(AppTranslations.tr('scan_qr')),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: const BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: const Color(0xFFF2F4F7),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTranslations.tr('services'),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 18),
                          _PaymentTile(
                            icon: Icons.account_balance_wallet_outlined,
                            iconBg: const Color(0xFFDDEBFB),
                            title: AppTranslations.tr('care4u_wallet'),
                            subtitle: AppTranslations.tr('manage_wallet'),
                            onTap: () {
                              AppNavigator.pushNamed(
                                context,
                                RouteNames.paymentHistory,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _PaymentTile(
                            icon: Icons.qr_code_2_outlined,
                            iconBg: const Color(0xFFFFF0D9),
                            title: AppTranslations.tr('transfer_guide'),
                            subtitle: AppTranslations.tr('view_topup_guide'),
                            onTap: () {
                              AppNavigator.pushNamed(context, RouteNames.paymentTopup);
                            },
                          ),
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

  static String _formatMoney(int value) {
    final text = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return '${text}đ';
  }
}

class _PaymentTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF2F80ED)),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
