import '../../../../data/models/admin_order.dart';

abstract class AdminOrdersState {
  const AdminOrdersState();
}

class AdminOrdersInitialState extends AdminOrdersState {
  const AdminOrdersInitialState();
}

class AdminOrdersLoadingState extends AdminOrdersState {
  const AdminOrdersLoadingState();
}

class AdminOrdersLoadedState extends AdminOrdersState {
  final List<AdminOrder> orders;
  final bool isFromFallback;
  final String? message;

  const AdminOrdersLoadedState({
    required this.orders,
    this.isFromFallback = false,
    this.message,
  });

  AdminOrdersLoadedState copyWith({
    List<AdminOrder>? orders,
    bool? isFromFallback,
    String? message,
  }) {
    return AdminOrdersLoadedState(
      orders: orders ?? this.orders,
      isFromFallback: isFromFallback ?? this.isFromFallback,
      message: message,
    );
  }
}

class AdminOrdersErrorState extends AdminOrdersState {
  final String errorMessage;
  final List<AdminOrder> fallbackOrders;

  const AdminOrdersErrorState({
    required this.errorMessage,
    this.fallbackOrders = const [],
  });
}
