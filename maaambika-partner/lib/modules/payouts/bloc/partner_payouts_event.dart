abstract class PartnerPayoutsEvent {
  const PartnerPayoutsEvent();
}

class ExecutePayoutEvent extends PartnerPayoutsEvent {
  final String upiId;
  final int amount;

  const ExecutePayoutEvent({
    required this.upiId,
    required this.amount,
  });
}
