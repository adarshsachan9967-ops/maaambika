import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../data/fallback/fallback_partner_data.dart';
import '../models/requests/fetch_partner_orders_request.dart';
import '../models/responses/partner_orders_response.dart';
import '../repositories/partner_orders_repository.dart';
import 'partner_orders_event.dart';
import 'partner_orders_state.dart';

class PartnerOrdersBloc extends Bloc<PartnerOrdersEvent, PartnerOrdersState> {
  final PartnerOrdersRepository _ordersRepository;

  PartnerOrdersBloc({PartnerOrdersRepository? ordersRepository})
      : _ordersRepository = ordersRepository ?? PartnerOrdersRepositoryImpl(),
        super(const PartnerOrdersInitialState()) {
    on<LoadPartnerOrdersEvent>(_onLoadOrders);
  }

  Future<void> _onLoadOrders(
    LoadPartnerOrdersEvent event,
    Emitter<PartnerOrdersState> emit,
  ) async {
    if (!event.isRefresh && state is! PartnerOrdersLoadedState) {
      emit(const PartnerOrdersLoadingState());
    }

    try {
      final response = await _ordersRepository.getOrders(
        const FetchPartnerOrdersRequest(),
      );

      if (response.statusCode == 200 && response.data != null && response.data is Map) {
        final parsed = PartnerOrdersResponse.fromJson(Map<String, dynamic>.from(response.data as Map));
        emit(
          PartnerOrdersLoadedState(
            orders: parsed.orders.isNotEmpty ? parsed.orders : FallbackPartnerData.orders,
            isFromFallback: parsed.orders.isEmpty,
          ),
        );
      } else {
        emit(
          const PartnerOrdersLoadedState(
            orders: FallbackPartnerData.orders,
            isFromFallback: true,
          ),
        );
      }
    } catch (e) {
      appLog("PartnerOrdersBloc error (falling back to local): $e");
      emit(
        const PartnerOrdersLoadedState(
          orders: FallbackPartnerData.orders,
          isFromFallback: true,
        ),
      );
    }
  }
}
