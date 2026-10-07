import '../../../../data/models/earnings_summary.dart';

class EarningsResponse {
  final bool success;
  final EarningsSummary summary;
  final String? message;

  EarningsResponse({
    required this.success,
    required this.summary,
    this.message,
  });

  factory EarningsResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final tripsList = (json['recentTrips'] as List<dynamic>?)
              ?.map((t) => TripEarning.fromMap(t as Map<String, dynamic>))
              .toList() ??
          [];
      return EarningsResponse(
        success: json['success'] as bool? ?? true,
        summary: EarningsSummary(
          walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 4890.0,
          todayEstimated: json['todayEstimated'] as String? ?? '₹1,090',
          completedTrips: json['completedTrips'] as int? ?? 4,
          targetTrips: json['targetTrips'] as int? ?? 6,
          incentiveBonus: (json['incentiveBonus'] as num?)?.toDouble() ?? 400.0,
          rating: (json['rating'] as num?)?.toDouble() ?? 4.95,
          recentTrips: tripsList,
        ),
        message: json['message'] as String?,
      );
    }
    return EarningsResponse(
      success: false,
      summary: EarningsSummary(
        walletBalance: 0,
        todayEstimated: '₹0',
        completedTrips: 0,
        targetTrips: 0,
        incentiveBonus: 0,
        rating: 0,
        recentTrips: [],
      ),
    );
  }
}
