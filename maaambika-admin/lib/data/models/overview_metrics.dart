class OverviewMetrics {
  final String todayGmv;
  final String gmvGrowth;
  final String totalOrders;
  final String pickupsCount;
  final String activeFleet;
  final String onTimeRate;
  final String netProfit;
  final String profitMargin;
  final int pendingApprovals;

  const OverviewMetrics({
    required this.todayGmv,
    required this.gmvGrowth,
    required this.totalOrders,
    required this.pickupsCount,
    required this.activeFleet,
    required this.onTimeRate,
    required this.netProfit,
    required this.profitMargin,
    required this.pendingApprovals,
  });

  factory OverviewMetrics.fromJson(Map<String, dynamic> json) {
    return OverviewMetrics(
      todayGmv: json['todayGmv']?.toString() ?? '₹24,85,920',
      gmvGrowth: json['gmvGrowth']?.toString() ?? '+18.4% vs yday',
      totalOrders: json['totalOrders']?.toString() ?? '142 Orders',
      pickupsCount: json['pickupsCount']?.toString() ?? '86 Pickups',
      activeFleet: json['activeFleet']?.toString() ?? '38 Fleet Active',
      onTimeRate: json['onTimeRate']?.toString() ?? '96% on-time',
      netProfit: json['netProfit']?.toString() ?? '₹3.4L Profit',
      profitMargin: json['profitMargin']?.toString() ?? '13.8% Margin',
      pendingApprovals: json['pendingApprovals'] is int
          ? json['pendingApprovals'] as int
          : int.tryParse(json['pendingApprovals']?.toString() ?? '3') ?? 3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayGmv': todayGmv,
      'gmvGrowth': gmvGrowth,
      'totalOrders': totalOrders,
      'pickupsCount': pickupsCount,
      'activeFleet': activeFleet,
      'onTimeRate': onTimeRate,
      'netProfit': netProfit,
      'profitMargin': profitMargin,
      'pendingApprovals': pendingApprovals,
    };
  }
}
