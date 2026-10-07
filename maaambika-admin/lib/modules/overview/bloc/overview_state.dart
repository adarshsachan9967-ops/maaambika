import '../../../../data/models/overview_metrics.dart';
import '../../../../data/models/audit_activity.dart';

abstract class OverviewState {
  const OverviewState();
}

class OverviewInitialState extends OverviewState {
  const OverviewInitialState();
}

class OverviewLoadingState extends OverviewState {
  const OverviewLoadingState();
}

class OverviewLoadedState extends OverviewState {
  final OverviewMetrics metrics;
  final List<AuditActivity> activities;
  final bool isFromFallback;

  const OverviewLoadedState({
    required this.metrics,
    required this.activities,
    this.isFromFallback = false,
  });
}

class OverviewErrorState extends OverviewState {
  final String errorMessage;
  final OverviewMetrics? fallbackMetrics;
  final List<AuditActivity> fallbackActivities;

  const OverviewErrorState({
    required this.errorMessage,
    this.fallbackMetrics,
    this.fallbackActivities = const [],
  });
}
