import '../../../core/services/api_service.dart';
import '../../../models/user_order.dart';

class OrdersRepository {
  Future<List<UserOrder>> fetchOrders(String phone) async {
    final list = await ApiService.fetchOrders(phone: phone);
    return list.map((json) => UserOrder.fromJson(json)).toList();
  }

  Future<UserOrder?> createOrder(Map<String, dynamic> orderData) async {
    final created = await ApiService.createOrder(orderData);
    if (created != null) {
      return UserOrder.fromJson(created);
    }
    return null;
  }
}
