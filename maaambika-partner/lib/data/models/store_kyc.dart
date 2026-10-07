class StoreKYC {
  final String storeName;
  final String gstin;
  final String address;
  final String tier;
  final bool isVerified;
  final String operatingHours;

  const StoreKYC({
    required this.storeName,
    required this.gstin,
    required this.address,
    required this.tier,
    required this.isVerified,
    required this.operatingHours,
  });

  factory StoreKYC.fromJson(Map<String, dynamic> json) {
    return StoreKYC(
      storeName: json['storeName']?.toString() ?? '',
      gstin: json['gstin']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      tier: json['tier']?.toString() ?? 'Gold Tier',
      isVerified: json['isVerified'] == true,
      operatingHours: json['operatingHours']?.toString() ?? '10:00 AM - 08:30 PM (Mon - Sun)',
    );
  }
}
