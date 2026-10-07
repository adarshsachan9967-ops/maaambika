class TripEarning {
  final String id;
  final String title;
  final String date;
  final String amount;
  final String breakdown;

  TripEarning({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.breakdown,
  });

  factory TripEarning.fromMap(Map<String, dynamic> map) {
    return TripEarning(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      date: map['date'] as String? ?? '',
      amount: map['amount'] as String? ?? '',
      breakdown: map['breakdown'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'amount': amount,
      'breakdown': breakdown,
    };
  }
}

class EarningsSummary {
  final double walletBalance;
  final String todayEstimated;
  final int completedTrips;
  final int targetTrips;
  final double incentiveBonus;
  final double rating;
  final List<TripEarning> recentTrips;

  EarningsSummary({
    required this.walletBalance,
    required this.todayEstimated,
    required this.completedTrips,
    required this.targetTrips,
    required this.incentiveBonus,
    required this.rating,
    required this.recentTrips,
  });

  double get completionRatio => targetTrips > 0 ? (completedTrips / targetTrips).clamp(0.0, 1.0) : 0.0;
  int get tripsLeft => (targetTrips - completedTrips).clamp(0, targetTrips);
}
