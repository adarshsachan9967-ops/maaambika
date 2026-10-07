import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';

class RentalDetailView extends StatelessWidget {
  final Map<String, dynamic> rental;
  final VoidCallback onBack;
  final VoidCallback onProceedToCheckout;

  const RentalDetailView({
    super.key,
    required this.rental,
    required this.onBack,
    required this.onProceedToCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final title = '${rental['brand'] ?? ''} ${rental['model'] ?? ''}'.trim();
    final dailyRate = rental['dailyRate'] ?? 0;
    final deposit = rental['securityDeposit'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(rental['specs'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Daily Rental Rate:'),
                        Text('${formatCurrency(dailyRate)}/day', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF059669))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Refundable Security Deposit:'),
                        Text(formatCurrency(deposit), style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: onProceedToCheckout,
                child: const Text('Proceed to Booking Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
