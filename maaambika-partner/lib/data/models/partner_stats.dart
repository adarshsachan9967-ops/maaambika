class PartnerStats {
  final int todayVolume;
  final double growthVsYesterday;
  final int devicesLiquidated;
  final int floatBalance;
  final int commissionEarned;

  const PartnerStats({
    required this.todayVolume,
    required this.growthVsYesterday,
    required this.devicesLiquidated,
    required this.floatBalance,
    required this.commissionEarned,
  });

  factory PartnerStats.fromJson(Map<String, dynamic> json) {
    return PartnerStats(
      todayVolume: (json['todayVolume'] as num?)?.toInt() ?? 0,
      growthVsYesterday: (json['growthVsYesterday'] as num?)?.toDouble() ?? 0.0,
      devicesLiquidated: (json['devicesLiquidated'] as num?)?.toInt() ?? 0,
      floatBalance: (json['floatBalance'] as num?)?.toInt() ?? 0,
      commissionEarned: (json['commissionEarned'] as num?)?.toInt() ?? 0,
    );
  }
}
