import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class IncentiveCard extends StatelessWidget {
  final int completed;
  final int total;
  final String bonusAmount;

  const IncentiveCard({
    super.key,
    this.completed = 4,
    this.total = 6,
    this.bonusAmount = '+₹400 Bonus',
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;
    final tripsLeft = (total - completed).clamp(0, total);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.borderSlate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.bolt, color: Color(0xFFF59E0B)),
                  SizedBox(width: 6),
                  Text('Super Shift Incentive', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Text(
                bonusAmount,
                style: const TextStyle(color: AppConstants.secondaryColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Complete 6 deliveries today between 10 AM - 7 PM to unlock ₹400 extra bonus!',
            style: TextStyle(fontSize: 12, color: AppConstants.textSlate),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completed of $total completed',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
              ),
              Text(
                '$tripsLeft trips left',
                style: const TextStyle(fontSize: 12, color: AppConstants.textSlate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
