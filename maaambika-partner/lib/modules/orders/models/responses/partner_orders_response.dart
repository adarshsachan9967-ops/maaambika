import '../../../../data/models/partner_order.dart';

class PartnerOrdersResponse {
  final bool success;
  final List<PartnerOrder> orders;
  final String? message;

  const PartnerOrdersResponse({
    required this.success,
    required this.orders,
    this.message,
  });

  factory PartnerOrdersResponse.fromJson(Map<String, dynamic> json) {
    final list = <PartnerOrder>[];
    if (json['data'] is List) {
      for (final item in json['data'] as List) {
        if (item is Map) {
          list.add(PartnerOrder.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    } else if (json['orders'] is List) {
      for (final item in json['orders'] as List) {
        if (item is Map) {
          list.add(PartnerOrder.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return PartnerOrdersResponse(
      success: json['success'] == true,
      orders: list,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'orders': orders.map((o) => o.toJson()).toList(),
      if (message != null) 'message': message,
    };
  }
}
