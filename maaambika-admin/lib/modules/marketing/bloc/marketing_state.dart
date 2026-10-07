import '../../../../data/models/promo_coupon.dart';

abstract class MarketingState {
  const MarketingState();
}

class MarketingInitialState extends MarketingState {
  const MarketingInitialState();
}

class MarketingLoadingState extends MarketingState {
  const MarketingLoadingState();
}

class MarketingLoadedState extends MarketingState {
  final List<PromoCoupon> coupons;
  final bool isFromFallback;
  final String? broadcastSuccessMessage;

  const MarketingLoadedState({
    required this.coupons,
    this.isFromFallback = false,
    this.broadcastSuccessMessage,
  });

  MarketingLoadedState copyWith({
    List<PromoCoupon>? coupons,
    bool? isFromFallback,
    String? broadcastSuccessMessage,
  }) {
    return MarketingLoadedState(
      coupons: coupons ?? this.coupons,
      isFromFallback: isFromFallback ?? this.isFromFallback,
      broadcastSuccessMessage: broadcastSuccessMessage,
    );
  }
}

class MarketingErrorState extends MarketingState {
  final String errorMessage;
  final List<PromoCoupon> fallbackCoupons;

  const MarketingErrorState({
    required this.errorMessage,
    this.fallbackCoupons = const [],
  });
}
