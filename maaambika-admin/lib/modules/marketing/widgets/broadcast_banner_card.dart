import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BroadcastBannerCard extends StatelessWidget {
  final VoidCallback onComposePressed;

  const BroadcastBannerCard({
    super.key,
    required this.onComposePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                'Send Instant Push Notification',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Deliver real-time alerts to all 12,450+ installed customer & rider apps.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.send, size: 16, color: Color(0xFF4F46E5)),
            label: const Text(
              'Compose Broadcast',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: onComposePressed,
          ),
        ],
      ),
    );
  }
}
