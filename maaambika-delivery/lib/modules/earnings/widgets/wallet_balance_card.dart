import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/helpers.dart';

class WalletBalanceCard extends StatelessWidget {
  final double balance;
  final VoidCallback? onPayoutInitiated;

  const WalletBalanceCard({
    super.key,
    this.balance = 4890.00,
    this.onPayoutInitiated,
  });

  @override
  Widget build(BuildContext context) {
    final formattedBalance = CurrencyFormatter.format(balance);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppConstants.primaryDark, AppConstants.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
              Icon(Icons.account_balance_wallet, color: Colors.white70, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formattedBalance,
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send_to_mobile, size: 16, color: AppConstants.primaryDark),
                  label: const Text(
                    'Instant Payout',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppConstants.primaryDark),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    onPayoutInitiated?.call();
                    Helpers.showSuccessSnackbar(
                      'Instant Payout Initiated',
                      'Transfer of $formattedBalance initiated to your HDFC Bank account!',
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Statement PDF downloaded to device.')),
                  );
                },
                child: const Text('Statement'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
