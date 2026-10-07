import '../../../../data/models/store_kyc.dart';

class PartnerProfileResponse {
  final bool success;
  final StoreKYC store;
  final String? message;

  const PartnerProfileResponse({
    required this.success,
    required this.store,
    this.message,
  });

  factory PartnerProfileResponse.fromJson(Map<String, dynamic> json) {
    final storeData = json['store'] is Map
        ? StoreKYC.fromJson(Map<String, dynamic>.from(json['store'] as Map))
        : const StoreKYC(
            storeName: 'TechWorld Hub',
            gstin: '07AAAAA0000A1Z5',
            address: 'Karol Bagh Main Market, New Delhi',
            tier: 'Gold Tier',
            isVerified: true,
            operatingHours: '10:00 AM - 08:30 PM (Mon - Sun)',
          );

    return PartnerProfileResponse(
      success: json['success'] == true,
      store: storeData,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'store': {
        'storeName': store.storeName,
        'gstin': store.gstin,
        'address': store.address,
        'tier': store.tier,
        'isVerified': store.isVerified,
        'operatingHours': store.operatingHours,
      },
      if (message != null) 'message': message,
    };
  }
}
