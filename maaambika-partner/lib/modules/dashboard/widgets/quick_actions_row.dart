import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class QuickActionsRow extends StatelessWidget {
  final VoidCallback onInspectTap;
  final VoidCallback onPayoutTap;

  const QuickActionsRow({
    super.key,
    required this.onInspectTap,
    required this.onPayoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.qr_code_scanner, size: 18),
            label: const Text('New Inspection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            onPressed: onInspectTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.flash_on, size: 18),
            label: const Text('Spot Payout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            onPressed: onPayoutTap,
          ),
        ),
      ],
    );
  }
}
