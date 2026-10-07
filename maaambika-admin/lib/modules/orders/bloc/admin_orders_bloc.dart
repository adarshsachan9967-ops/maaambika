import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../data/fallback/fallback_admin_data.dart';
import '../../../../data/models/admin_order.dart';
import '../models/requests/assign_rider_request.dart';
import '../models/requests/fetch_admin_orders_request.dart';
import '../models/responses/admin_orders_response.dart';
import '../repositories/admin_orders_repository.dart';
import 'admin_orders_event.dart';
import 'admin_orders_state.dart';

class AdminOrdersBloc extends Bloc<AdminOrdersEvent, AdminOrdersState> {
  final AdminOrdersRepository _ordersRepository;

  AdminOrdersBloc({AdminOrdersRepository? ordersRepository})
      : _ordersRepository = ordersRepository ?? AdminOrdersRepositoryImpl(),
        super(const AdminOrdersInitialState()) {
    on<LoadAdminOrdersEvent>(_onLoadOrders);
    on<AssignRiderEvent>(_onAssignRider);
  }

  Future<void> _onLoadOrders(
    LoadAdminOrdersEvent event,
    Emitter<AdminOrdersState> emit,
  ) async {
    if (!event.isRefresh && state is! AdminOrdersLoadedState) {
      emit(const AdminOrdersLoadingState());
    }

    try {
      final response = await _ordersRepository.getOrders(
        const FetchAdminOrdersRequest(),
      );

      if (response.statusCode == 200 && response.data != null && response.data is Map) {
        final parsed = AdminOrdersResponse.fromJson(Map<String, dynamic>.from(response.data as Map));
        emit(
          AdminOrdersLoadedState(
            orders: parsed.orders.isNotEmpty ? parsed.orders : FallbackAdminData.defaultOrders,
            isFromFallback: parsed.orders.isEmpty,
          ),
        );
      } else {
        emit(
          AdminOrdersLoadedState(
            orders: FallbackAdminData.defaultOrders,
            isFromFallback: true,
          ),
        );
      }
    } catch (e) {
      appLog("AdminOrdersBloc error (falling back to local): $e");
      emit(
        AdminOrdersLoadedState(
          orders: FallbackAdminData.defaultOrders,
          isFromFallback: true,
        ),
      );
    }
  }

  Future<void> _onAssignRider(
    AssignRiderEvent event,
    Emitter<AdminOrdersState> emit,
  ) async {
    List<AdminOrder> currentOrders = [];
    if (state is AdminOrdersLoadedState) {
      currentOrders = (state as AdminOrdersLoadedState).orders;
    } else {
      currentOrders = List.from(FallbackAdminData.defaultOrders);
    }

    // Optimistic / Local update first
    final updatedList = currentOrders.map((o) {
      if (o.id == event.orderId) {
        return o.copyWith(
          assignedRider: '${event.riderName} (${event.riderId})',
          status: 'Assigned',
        );
      }
      return o;
    }).toList();

    emit(
      AdminOrdersLoadedState(
        orders: updatedList,
        message: 'Dispatched order ${event.orderId} to ${event.riderName}!',
      ),
    );

    // Call API in background
    try {
      await _ordersRepository.assignRider(
        AssignRiderRequest(
          orderId: event.orderId,
          riderId: event.riderId,
          riderName: event.riderName,
        ),
      );
    } catch (e) {
      appLog("AssignRider API sync note: $e");
    }
  }
}
