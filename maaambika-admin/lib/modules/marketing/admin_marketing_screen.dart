import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/helpers.dart';
import 'bloc/marketing_bloc.dart';
import 'bloc/marketing_event.dart';
import 'bloc/marketing_state.dart';
import 'widgets/broadcast_banner_card.dart';
import 'widgets/broadcast_composer_dialog.dart';
import 'widgets/coupon_card.dart';

class AdminMarketingScreen extends StatelessWidget {
  const AdminMarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketingBloc, MarketingState>(
      listener: (context, state) {
        if (state is MarketingLoadedState && state.broadcastSuccessMessage != null) {
          Helpers.showSuccessSnackbar('Broadcast Sent', state.broadcastSuccessMessage!);
        }
      },
      builder: (context, state) {
        if (state is MarketingLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final coupons = state is MarketingLoadedState ? state.coupons : [];

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context.read<MarketingBloc>().add(const LoadMarketingEvent(isRefresh: true));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Push Campaigns & Coupons',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Broadcast announcements and manage discount promotions across customer devices.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),

                // Broadcast Card
                BroadcastBannerCard(
                  onComposePressed: () {
                    BroadcastComposerDialog.show(context, (title, body) {
                      context.read<MarketingBloc>().add(
                            DispatchBroadcastEvent(title: title, body: body),
                          );
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Active Coupons
                const Text(
                  'Active Promo Codes',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),
                if (coupons.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No active promo codes found',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    ),
                  )
                else
                  ...coupons.map((c) => CouponCard(coupon: c)),
              ],
            ),
          ),
        );
      },
    );
  }
}
