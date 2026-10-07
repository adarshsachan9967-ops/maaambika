abstract class OverviewEvent {
  const OverviewEvent();
}

class LoadOverviewEvent extends OverviewEvent {
  final bool isRefresh;
  const LoadOverviewEvent({this.isRefresh = false});
}
