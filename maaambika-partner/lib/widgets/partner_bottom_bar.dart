import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class PartnerBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const PartnerBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemSelected,
      backgroundColor: Colors.white,
      indicatorColor: AppConstants.primaryColor.withValues(alpha: 0.18),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard, color: AppConstants.primaryColor),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag, color: AppConstants.primaryColor),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.fact_check_outlined),
          selectedIcon: Icon(Icons.fact_check, color: AppConstants.primaryColor),
          label: 'Inspection',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet, color: AppConstants.primaryColor),
          label: 'Payouts',
        ),
        NavigationDestination(
          icon: Icon(Icons.store_outlined),
          selectedIcon: Icon(Icons.store, color: AppConstants.primaryColor),
          label: 'Store KYC',
        ),
      ],
    );
  }
}
