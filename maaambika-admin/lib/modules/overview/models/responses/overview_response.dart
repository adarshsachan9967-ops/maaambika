import '../../../../data/models/overview_metrics.dart';
import '../../../../data/models/audit_activity.dart';

class OverviewResponse {
  final bool success;
  final OverviewMetrics metrics;
  final List<AuditActivity> activities;
  final String? message;

  const OverviewResponse({
    required this.success,
    required this.metrics,
    required this.activities,
    this.message,
  });

  factory OverviewResponse.fromJson(Map<String, dynamic> json) {
    final metricsData = json['metrics'] is Map
        ? OverviewMetrics.fromJson(Map<String, dynamic>.from(json['metrics'] as Map))
        : const OverviewMetrics(
            todayGmv: '₹24,85,920',
            gmvGrowth: '+18.4% vs yday',
            totalOrders: '142 Orders',
            pickupsCount: '86 Pickups',
            activeFleet: '38 Fleet Active',
            onTimeRate: '96% on-time',
            netProfit: '₹3.4L Profit',
            profitMargin: '13.8% Margin',
            pendingApprovals: 3,
          );

    final activitiesList = <AuditActivity>[];
    if (json['activities'] is List) {
      for (final a in json['activities'] as List) {
        if (a is Map) {
          activitiesList.add(AuditActivity.fromJson(Map<String, dynamic>.from(a)));
        }
      }
    }

    return OverviewResponse(
      success: json['success'] == true,
      metrics: metricsData,
      activities: activitiesList,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'metrics': metrics.toJson(),
      'activities': activities.map((a) => a.toJson()).toList(),
      if (message != null) 'message': message,
    };
  }
}
