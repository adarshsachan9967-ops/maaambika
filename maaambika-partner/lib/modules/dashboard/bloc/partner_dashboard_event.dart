abstract class PartnerDashboardEvent {
  const PartnerDashboardEvent();
}

class LoadPartnerDashboardEvent extends PartnerDashboardEvent {
  final bool isRefresh;
  const LoadPartnerDashboardEvent({this.isRefresh = false});
}
