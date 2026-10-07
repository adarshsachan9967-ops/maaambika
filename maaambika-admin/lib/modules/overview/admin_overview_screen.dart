import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../data/fallback/fallback_admin_data.dart';
import 'bloc/overview_bloc.dart';
import 'bloc/overview_event.dart';
import 'bloc/overview_state.dart';
import 'widgets/executive_gmv_card.dart';
import 'widgets/action_alert_banner.dart';
import 'widgets/health_card.dart';
import 'widgets/activity_tile.dart';

class AdminOverviewScreen extends StatelessWidget {
  final VoidCallback onReviewPartners;

  const AdminOverviewScreen({
    super.key,
    required this.onReviewPartners,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewBloc, OverviewState>(
      builder: (context, state) {
        if (state is OverviewLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final metrics = state is OverviewLoadedState
            ? state.metrics
            : FallbackAdminData.defaultMetrics;
        final activities = state is OverviewLoadedState
            ? state.activities
            : FallbackAdminData.defaultActivities;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context.read<OverviewBloc>().add(const LoadOverviewEvent(isRefresh: true));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Executive GMV Card
                ExecutiveGmvCard(metrics: metrics),
                const SizedBox(height: 20),

                // Action Items & Alerts
                ActionAlertBanner(
                  pendingCount: metrics.pendingApprovals,
                  onReviewPressed: onReviewPartners,
                ),
                const SizedBox(height: 20),

                // Live Infrastructure Health
                const Text(
                  'Platform & Cloud Health',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: HealthCard(
                        title: 'API Cluster',
                        desc: '42ms Latency',
                        icon: Icons.bolt,
                        color: AppColors.emerald,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: HealthCard(
                        title: 'Payments (Razorpay)',
                        desc: '99.9% Success',
                        icon: Icons.credit_card,
                        color: AppColors.emerald,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: HealthCard(
                        title: 'Rider GPS Dispatch',
                        desc: '34 Active Nodes',
                        icon: Icons.radar,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: HealthCard(
                        title: 'SMS & WhatsApp',
                        desc: '100% Delivered',
                        icon: Icons.sms,
                        color: AppColors.emerald,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Live Platform Audit Log Feed
                const Text(
                  'Live Platform Audit Log',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),
                ...activities.map((a) => ActivityTile(activity: a)),
              ],
            ),
          ),
        );
      },
    );
  }
}
