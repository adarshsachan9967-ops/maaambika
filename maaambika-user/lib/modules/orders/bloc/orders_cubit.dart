import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/user_order.dart';
import '../data/orders_repository.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _repository;

  OrdersCubit({OrdersRepository? repository})
      : _repository = repository ?? OrdersRepository(),
        super(const OrdersInitial());

  Future<void> loadOrders(String phone) async {
    if (phone.isEmpty) {
      emit(const OrdersLoaded([]));
      return;
    }
    emit(const OrdersLoading());
    try {
      final orders = await _repository.fetchOrders(phone);
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  void addOrder(UserOrder order) {
    if (state is OrdersLoaded) {
      final current = (state as OrdersLoaded).orders;
      emit(OrdersLoaded([order, ...current]));
    } else {
      emit(OrdersLoaded([order]));
    }
  }
}
