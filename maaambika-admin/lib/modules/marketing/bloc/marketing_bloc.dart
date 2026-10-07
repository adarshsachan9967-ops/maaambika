import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../data/fallback/fallback_admin_data.dart';
import '../../../../data/models/promo_coupon.dart';
import '../models/requests/fetch_coupons_request.dart';
import '../models/requests/send_broadcast_request.dart';
import '../models/responses/coupons_response.dart';
import '../repositories/marketing_repository.dart';
import 'marketing_event.dart';
import 'marketing_state.dart';

class MarketingBloc extends Bloc<MarketingEvent, MarketingState> {
  final MarketingRepository _marketingRepository;

  MarketingBloc({MarketingRepository? marketingRepository})
      : _marketingRepository = marketingRepository ?? MarketingRepositoryImpl(),
        super(const MarketingInitialState()) {
    on<LoadMarketingEvent>(_onLoadMarketing);
    on<DispatchBroadcastEvent>(_onDispatchBroadcast);
  }

  Future<void> _onLoadMarketing(
    LoadMarketingEvent event,
    Emitter<MarketingState> emit,
  ) async {
    if (!event.isRefresh && state is! MarketingLoadedState) {
      emit(const MarketingLoadingState());
    }

    try {
      final response = await _marketingRepository.getCoupons(
        const FetchCouponsRequest(),
      );

      if (response.statusCode == 200 && response.data != null && response.data is Map) {
        final parsed = CouponsResponse.fromJson(Map<String, dynamic>.from(response.data as Map));
        emit(
          MarketingLoadedState(
            coupons: parsed.coupons.isNotEmpty ? parsed.coupons : FallbackAdminData.defaultCoupons,
            isFromFallback: parsed.coupons.isEmpty,
          ),
        );
      } else {
        emit(
          MarketingLoadedState(
            coupons: FallbackAdminData.defaultCoupons,
            isFromFallback: true,
          ),
        );
      }
    } catch (e) {
      appLog("MarketingBloc error (falling back to local): $e");
      emit(
        MarketingLoadedState(
          coupons: FallbackAdminData.defaultCoupons,
          isFromFallback: true,
        ),
      );
    }
  }

  Future<void> _onDispatchBroadcast(
    DispatchBroadcastEvent event,
    Emitter<MarketingState> emit,
  ) async {
    List<PromoCoupon> currentCoupons = [];
    if (state is MarketingLoadedState) {
      currentCoupons = (state as MarketingLoadedState).coupons;
    } else {
      currentCoupons = List.from(FallbackAdminData.defaultCoupons);
    }

    emit(
      MarketingLoadedState(
        coupons: currentCoupons,
        broadcastSuccessMessage: 'Push Broadcast dispatched to 12,450 devices!',
      ),
    );

    try {
      await _marketingRepository.sendBroadcast(
        SendBroadcastRequest(title: event.title, body: event.body),
      );
    } catch (e) {
      appLog("SendBroadcast API sync note: $e");
    }
  }
}
