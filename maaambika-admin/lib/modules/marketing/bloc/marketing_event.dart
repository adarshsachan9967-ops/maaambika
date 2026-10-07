abstract class MarketingEvent {
  const MarketingEvent();
}

class LoadMarketingEvent extends MarketingEvent {
  final bool isRefresh;
  const LoadMarketingEvent({this.isRefresh = false});
}

class DispatchBroadcastEvent extends MarketingEvent {
  final String title;
  final String body;

  const DispatchBroadcastEvent({
    required this.title,
    required this.body,
  });
}
