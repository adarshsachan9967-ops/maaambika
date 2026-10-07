import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../data/fallback/fallback_partner_data.dart';
import 'bloc/partner_dashboard_bloc.dart';
import 'bloc/partner_dashboard_event.dart';
import 'bloc/partner_dashboard_state.dart';
import 'widgets/queue_card.dart';
import 'widgets/quick_actions_row.dart';
import 'widgets/volume_metric_card.dart';

class PartnerDashboardScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const PartnerDashboardScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnerDashboardBloc, PartnerDashboardState>(
      builder: (context, state) {
        if (state is PartnerDashboardLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final stats = state is PartnerDashboardLoadedState
            ? state.stats
            : FallbackPartnerData.stats;
        final pendingQueue = state is PartnerDashboardLoadedState
            ? state.pendingQueue
            : FallbackPartnerData.pendingQueue;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context.read<PartnerDashboardBloc>().add(
                  const LoadPartnerDashboardEvent(isRefresh: true),
                );
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // Revenue & Volume Card
              VolumeMetricCard(stats: stats),

              const SizedBox(height: 20),

              // Quick Actions Row
              QuickActionsRow(
                onInspectTap: () => onNavigate(2),
                onPayoutTap: () => onNavigate(3),
              ),

              const SizedBox(height: 24),
              const Text(
                'Pending Store Queue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              ...pendingQueue.map(
                (item) => QueueCard(
                  model: item['model'] ?? '',
                  customer: item['customer'] ?? '',
                  quote: item['quote'] ?? '',
                  status: item['status'] ?? '',
                  onInspect: () => onNavigate(2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
