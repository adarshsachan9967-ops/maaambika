import '../../../../data/models/partner_stats.dart';

class DashboardResponse {
  final bool success;
  final PartnerStats stats;
  final List<Map<String, String>> pendingQueue;
  final String? message;

  const DashboardResponse({
    required this.success,
    required this.stats,
    required this.pendingQueue,
    this.message,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    final statsData = json['stats'] is Map
        ? PartnerStats.fromJson(Map<String, dynamic>.from(json['stats'] as Map))
        : const PartnerStats(
            todayVolume: 48250,
            growthVsYesterday: 18.4,
            devicesLiquidated: 7,
            floatBalance: 250000,
            commissionEarned: 5790,
          );

    final queueList = <Map<String, String>>[];
    if (json['pendingQueue'] is List) {
      for (final item in json['pendingQueue'] as List) {
        if (item is Map) {
          queueList.add(item.map((k, v) => MapEntry(k.toString(), v.toString())));
        }
      }
    }

    return DashboardResponse(
      success: json['success'] == true,
      stats: statsData,
      pendingQueue: queueList,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'stats': {
        'todayVolume': stats.todayVolume,
        'growthVsYesterday': stats.growthVsYesterday,
        'devicesLiquidated': stats.devicesLiquidated,
        'floatBalance': stats.floatBalance,
        'commissionEarned': stats.commissionEarned,
      },
      'pendingQueue': pendingQueue,
      if (message != null) 'message': message,
    };
  }
}
