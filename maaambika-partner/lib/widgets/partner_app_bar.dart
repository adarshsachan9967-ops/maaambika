import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../data/models/store_kyc.dart';
import 'notifications_modal.dart';

class PartnerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final StoreKYC store;
  final VoidCallback? onRefresh;

  const PartnerAppBar({
    super.key,
    required this.store,
    this.onRefresh,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.darkBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.goldBadge, width: 1),
            ),
            child: Image.asset(
              'assets/images/app_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => const Icon(
                Icons.storefront,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MAA AMBIKA PARTNER',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1.1),
                ),
                Text(
                  '${store.storeName} ${AppConstants.bulletSymbol} ${store.address.split(',').first}',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.goldBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, color: AppColors.goldBadge, size: 14),
              const SizedBox(width: 4),
              Text(
                store.tier,
                style: const TextStyle(
                  color: AppColors.goldText,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => NotificationsModal.show(context),
        ),
      ],
    );
  }
}
