import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';

class SummaryStep extends StatelessWidget {
  final String deviceName;
  final int quoteAmount;
  final VoidCallback onProceedToPickup;

  const SummaryStep({
    super.key,
    required this.deviceName,
    required this.quoteAmount,
    required this.onProceedToPickup,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Text('Guaranteed Resale Valuation', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 8),
                Text(
                  formatCurrency(quoteAmount),
                  style: const TextStyle(color: Color(0xFF34D399), fontSize: 36, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Text(
                  deviceName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white12),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flash_on, color: Color(0xFFFBBF24), size: 16),
                    SizedBox(width: 6),
                    Text('Spot Instant UPI Payout at Doorstep', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
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
              onPressed: onProceedToPickup,
              child: const Text('Book Free Doorstep Pickup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
