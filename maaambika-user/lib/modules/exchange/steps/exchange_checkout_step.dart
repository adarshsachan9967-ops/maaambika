import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';

class ExchangeCheckoutStep extends StatelessWidget {
  final Map<String, dynamic> oldDevice;
  final Map<String, dynamic> newDevice;
  final int tradeInValue;
  final int bonus;
  final int differenceToPay;
  final VoidCallback onConfirmExchange;

  const ExchangeCheckoutStep({
    super.key,
    required this.oldDevice,
    required this.newDevice,
    required this.tradeInValue,
    required this.bonus,
    required this.differenceToPay,
    required this.onConfirmExchange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Old Device Valuation:'),
                      Text(formatCurrency(tradeInValue), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Maa Ambika Exchange Bonus:'),
                      Text('+ ${formatCurrency(bonus)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Upgrade Product Price:'),
                      Text(formatCurrency(newDevice['sellingPrice'] ?? 0), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Net Difference to Pay:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(formatCurrency(differenceToPay), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF7C3AED))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: onConfirmExchange,
              child: const Text('Confirm Doorstep 1-Step Swap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
