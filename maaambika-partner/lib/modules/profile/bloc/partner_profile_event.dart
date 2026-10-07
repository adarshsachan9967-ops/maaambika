abstract class PartnerProfileEvent {
  const PartnerProfileEvent();
}

class LoadPartnerProfileEvent extends PartnerProfileEvent {
  final bool isRefresh;
  const LoadPartnerProfileEvent({this.isRefresh = false});
}

class LogoutPartnerEvent extends PartnerProfileEvent {
  const LogoutPartnerEvent();
}
