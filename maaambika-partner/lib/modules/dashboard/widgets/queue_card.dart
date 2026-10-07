import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class QueueCard extends StatelessWidget {
  final String model;
  final String customer;
  final String quote;
  final String status;
  final VoidCallback onInspect;

  const QueueCard({
    super.key,
    required this.model,
    required this.customer,
    required this.quote,
    required this.status,
    required this.onInspect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(customer, style: const TextStyle(color: Colors.black54, fontSize: 11)),
              const SizedBox(height: 4),
              Text(quote, style: const TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEFF6FF),
              foregroundColor: AppConstants.primaryColor,
              elevation: 0,
            ),
            onPressed: onInspect,
            child: const Text('Inspect', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
