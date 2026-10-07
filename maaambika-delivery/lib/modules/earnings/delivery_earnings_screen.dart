import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import 'bloc/earnings_bloc.dart';
import 'bloc/earnings_event.dart';
import 'bloc/earnings_state.dart';
import 'widgets/incentive_card.dart';
import 'widgets/trip_earning_tile.dart';
import 'widgets/wallet_balance_card.dart';

class DeliveryEarningsScreen extends StatelessWidget {
  const DeliveryEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EarningsBloc()..add(const LoadEarningsEvent()),
      child: BlocBuilder<EarningsBloc, EarningsState>(
        builder: (context, state) {
          if (state is EarningsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppConstants.primaryColor),
            );
          }

          if (state is EarningsError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: AppConstants.errorRed),
              ),
            );
          }

          if (state is EarningsLoaded) {
            final summary = state.summary;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Wallet Card
                  WalletBalanceCard(
                    balance: summary.walletBalance,
                    onPayoutInitiated: () {
                      context
                          .read<EarningsBloc>()
                          .add(RequestInstantPayoutEvent(summary.walletBalance));
                    },
                  ),
                  const SizedBox(height: 20),

                  // Daily Incentive Challenge
                  IncentiveCard(
                    completed: summary.completedTrips,
                    total: summary.targetTrips,
                  ),
                  const SizedBox(height: 20),

                  // Earnings Breakdown
                  const Text(
                    'Recent Trip Earnings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...summary.recentTrips.map(
                    (trip) => TripEarningTile(earning: trip),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
