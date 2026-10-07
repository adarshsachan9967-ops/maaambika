import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';

class RentalCheckoutView extends StatelessWidget {
  final Map<String, dynamic> rental;
  final int days;
  final VoidCallback onBack;
  final VoidCallback onConfirmBooking;

  const RentalCheckoutView({
    super.key,
    required this.rental,
    required this.days,
    required this.onBack,
    required this.onConfirmBooking,
  });

  @override
  Widget build(BuildContext context) {
    final dailyRate = rental['dailyRate'] ?? 0;
    final totalRent = dailyRate * days;
    final deposit = rental['securityDeposit'] ?? 0;
    final grandTotal = totalRent + deposit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Booking Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Booking Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rental Duration ($days days):'),
                        Text(formatCurrency(totalRent), style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount Payable:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(formatCurrency(grandTotal), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF059669))),
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
                onPressed: onConfirmBooking,
                child: const Text('Confirm Rental Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
