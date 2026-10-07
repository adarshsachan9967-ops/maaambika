abstract class EarningsEvent {
  const EarningsEvent();
}

class LoadEarningsEvent extends EarningsEvent {
  const LoadEarningsEvent();
}

class RequestInstantPayoutEvent extends EarningsEvent {
  final double amount;
  const RequestInstantPayoutEvent(this.amount);
}
