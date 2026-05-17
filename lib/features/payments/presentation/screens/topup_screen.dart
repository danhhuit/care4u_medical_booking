import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Nạp tiền')),
      backgroundColor: const Color(0xFFF2F4F7),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Chọn số tiền',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
              decoration: InputDecoration(
                hintText: 'Hoặc nhập số tiền khác (Tối thiểu 10.000đ)',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (val) {
                setState(() {
                  selectedAmount = null; // Bỏ chọn chip nếu người dùng tự nhập
                });
              },
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phương thức thanh toán',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  _methodTile(
                    title: 'Chuyển khoản ngân hàng',
                    value: 'bank_transfer',
                  ),
                  const SizedBox(height: 12),
                  _methodTile(title: 'Thẻ tín dụng/Ghi nợ', value: 'card'),
                  const SizedBox(height: 12),
                  _methodTile(title: 'Ví MoMo', value: 'momo'),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isValidAmount ? () {} : null,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Tiếp tục'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _methodTile({required String title, required String value}) {
    final selected = selectedMethod == value;
    return InkWell(
      onTap: () => setState(() => selectedMethod = value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF2F80ED) : Colors.black12,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
