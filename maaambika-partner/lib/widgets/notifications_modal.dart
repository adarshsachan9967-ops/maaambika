import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

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
                'Partner Notifications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Mark all read',
                  style: TextStyle(fontSize: 12, color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          const ListTile(
            dense: true,
            leading: Icon(Icons.star, color: AppColors.goldBadge),
            title: Text(
              'Gold Tier Maintained',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            subtitle: Text(
              'Your store completed 140+ evaluations this month.',
              style: TextStyle(fontSize: 11),
            ),
          ),
          const ListTile(
            dense: true,
            leading: Icon(Icons.account_balance_wallet, color: AppColors.accentColor),
            title: Text(
              'Commission Credited',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            subtitle: Text(
              '₹5,790 store commissions deposited into your escrow account.',
              style: TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
