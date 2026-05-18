import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});

  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  final List<int> amounts = [50000, 100000, 200000, 500000, 1000000, 2000000];
  int? selectedAmount;
  String selectedMethod = 'bank_transfer';

  final TextEditingController _customAmountController = TextEditingController();

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  int get _finalAmount {
    if (selectedAmount != null) return selectedAmount!;
    final customVal = int.tryParse(_customAmountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return customVal;
  }

  bool get _isValidAmount => _finalAmount >= 10000;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      appBar: AppBar(title: Text(AppTranslations.tr('top_up'))),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppTranslations.tr('choose_amount') ?? 'Chọn số tiền',
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: amounts.map((amount) {
                final selected = selectedAmount == amount;
                return ChoiceChip(
                  label: Text(_formatMoney(amount)),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selectedAmount = amount;
                      _customAmountController.clear();
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _customAmountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: AppTranslations.tr('or_enter_amount') ?? 'Hoặc nhập số tiền khác (Tối thiểu 10.000đ)',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (val) {
                setState(() {
                  selectedAmount = null; 
                });
              },
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: isDark ? Colors.black45 : Colors.black12, blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslations.tr('payment_method') ?? 'Phương thức thanh toán',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _methodTile(
                    title: AppTranslations.tr('bank_transfer') ?? 'Chuyển khoản ngân hàng',
                    value: 'bank_transfer',
                    iconWidget: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF005DAA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _methodTile(
                    title: AppTranslations.tr('momo_wallet') ?? 'Ví MoMo', 
                    value: 'momo',
                    iconWidget: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA50064), // MoMo pink
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'mo\nmo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isValidAmount ? () {} : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(AppTranslations.tr('continue') ?? 'Tiếp tục'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _methodTile({required String title, required String value, required Widget iconWidget}) {
    final selected = selectedMethod == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () => setState(() => selectedMethod = value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF2F80ED) : (isDark ? Colors.white24 : Colors.black12),
            width: selected ? 1.6 : 1,
          ),
          color: selected ? const Color(0xFF2F80ED).withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: Color(0xFF2F80ED)),
          ],
        ),
      ),
    );
  }

  String _formatMoney(int value) {
    final text = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return '$textđ';
  }
}
