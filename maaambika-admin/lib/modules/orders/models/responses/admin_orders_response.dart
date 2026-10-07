import '../../../../data/models/admin_order.dart';

class AdminOrdersResponse {
  final bool success;
  final List<AdminOrder> orders;
  final String? message;

  const AdminOrdersResponse({
    required this.success,
    required this.orders,
    this.message,
  });

  factory AdminOrdersResponse.fromJson(Map<String, dynamic> json) {
    final list = <AdminOrder>[];
    if (json['data'] is List) {
      for (final item in json['data'] as List) {
        if (item is Map) {
          list.add(AdminOrder.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    } else if (json['orders'] is List) {
      for (final item in json['orders'] as List) {
        if (item is Map) {
          list.add(AdminOrder.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return AdminOrdersResponse(
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
