import '../../../../data/models/promo_coupon.dart';

class CouponsResponse {
  final bool success;
  final List<PromoCoupon> coupons;
  final String? message;

  const CouponsResponse({
    required this.success,
    required this.coupons,
    this.message,
  });

  factory CouponsResponse.fromJson(Map<String, dynamic> json) {
    final list = <PromoCoupon>[];
    if (json['data'] is List) {
      for (final item in json['data'] as List) {
        if (item is Map) {
          list.add(PromoCoupon.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    } else if (json['coupons'] is List) {
      for (final item in json['coupons'] as List) {
        if (item is Map) {
          list.add(PromoCoupon.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return CouponsResponse(
      success: json['success'] == true,
      coupons: list,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'coupons': coupons.map((c) => c.toJson()).toList(),
      if (message != null) 'message': message,
    };
  }
}
