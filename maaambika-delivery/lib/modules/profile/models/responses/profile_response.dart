class ProfileResponse {
  final bool success;
  final String riderId;
  final String name;
  final bool isKycVerified;
  final double rating;
  final String vehicle;
  final String license;
  final String bank;
  final String insurance;

  ProfileResponse({
    required this.success,
    required this.riderId,
    required this.name,
    required this.isKycVerified,
    required this.rating,
    required this.vehicle,
    required this.license,
    required this.bank,
    required this.insurance,
  });

  factory ProfileResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ProfileResponse(
        success: json['success'] as bool? ?? true,
        riderId: json['riderId'] as String? ?? 'CAS-RD-8842',
        name: json['name'] as String? ?? 'Rahul Sharma',
        isKycVerified: json['isKycVerified'] as bool? ?? true,
        rating: (json['rating'] as num?)?.toDouble() ?? 4.95,
        vehicle: json['vehicle'] as String? ?? 'Honda Activa 6G (KA-01-EQ-9812)',
        license: json['license'] as String? ?? 'DL-KA-20190038841 (Valid)',
        bank: json['bank'] as String? ?? 'HDFC Bank ending in **8491',
        insurance: json['insurance'] as String? ?? 'Maa Ambika Transit Cover Active (₹5 Lakh)',
      );
    }
    return ProfileResponse(
      success: false,
      riderId: 'CAS-RD-8842',
      name: 'Rahul Sharma',
      isKycVerified: true,
      rating: 4.95,
      vehicle: 'Honda Activa 6G (KA-01-EQ-9812)',
      license: 'DL-KA-20190038841 (Valid)',
      bank: 'HDFC Bank ending in **8491',
      insurance: 'Maa Ambika Transit Cover Active (₹5 Lakh)',
    );
  }
}
