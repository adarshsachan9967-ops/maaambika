abstract class PartnersEvent {
  const PartnersEvent();
}

class LoadPartnersEvent extends PartnersEvent {
  final bool isRefresh;
  const LoadPartnersEvent({this.isRefresh = false});
}

class ApproveKycEvent extends PartnersEvent {
  final String partnerName;

  const ApproveKycEvent({required this.partnerName});
}
