abstract class PartnerOrdersEvent {
  const PartnerOrdersEvent();
}

class LoadPartnerOrdersEvent extends PartnerOrdersEvent {
  final bool isRefresh;
  const LoadPartnerOrdersEvent({this.isRefresh = false});
}
