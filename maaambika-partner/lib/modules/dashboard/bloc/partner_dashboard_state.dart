import '../../../../data/models/partner_stats.dart';

abstract class PartnerDashboardState {
  const PartnerDashboardState();
}

class PartnerDashboardInitialState extends PartnerDashboardState {
  const PartnerDashboardInitialState();
}

class PartnerDashboardLoadingState extends PartnerDashboardState {
  const PartnerDashboardLoadingState();
}

class PartnerDashboardLoadedState extends PartnerDashboardState {
  final PartnerStats stats;
  final List<Map<String, String>> pendingQueue;
  final bool isFromFallback;

  const PartnerDashboardLoadedState({
    required this.stats,
    required this.pendingQueue,
    this.isFromFallback = false,
  });
}

class PartnerDashboardErrorState extends PartnerDashboardState {
  final String errorMessage;
  final PartnerStats? fallbackStats;
  final List<Map<String, String>> fallbackQueue;

  const PartnerDashboardErrorState({
    required this.errorMessage,
    this.fallbackStats,
    this.fallbackQueue = const [],
  });
}
