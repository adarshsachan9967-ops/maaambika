import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class NotificationsModal extends StatelessWidget {
  const NotificationsModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const NotificationsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rider Notifications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Mark all read',
                  style: TextStyle(fontSize: 12, color: AppConstants.primaryColor),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ListTile(
            dense: true,
            leading: const Icon(Icons.star, color: AppConstants.ratingGold),
            title: const Text(
              'Great Job! 5-Star feedback received',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            subtitle: const Text(
              'Customer Ananya Verma rated your handover as super professional.',
              style: TextStyle(fontSize: 11),
            ),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.attach_money, color: AppConstants.successGreen),
            title: const Text(
              'Daily payout processed',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            subtitle: const Text(
              '₹1,450 deposited into your bank account.',
              style: TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
