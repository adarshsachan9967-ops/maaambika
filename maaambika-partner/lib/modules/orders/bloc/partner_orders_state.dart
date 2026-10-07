import '../../../../data/models/partner_order.dart';

abstract class PartnerOrdersState {
  const PartnerOrdersState();
}

class PartnerOrdersInitialState extends PartnerOrdersState {
  const PartnerOrdersInitialState();
}

class PartnerOrdersLoadingState extends PartnerOrdersState {
  const PartnerOrdersLoadingState();
}

class PartnerOrdersLoadedState extends PartnerOrdersState {
  final List<PartnerOrder> orders;
  final bool isFromFallback;
  final String? message;

  const PartnerOrdersLoadedState({
    required this.orders,
    this.isFromFallback = false,
    this.message,
  });
}

class PartnerOrdersErrorState extends PartnerOrdersState {
  final String errorMessage;
  final List<PartnerOrder> fallbackOrders;

  const PartnerOrdersErrorState({
    required this.errorMessage,
    this.fallbackOrders = const [],
  });
}
