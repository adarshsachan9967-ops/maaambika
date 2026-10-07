abstract class PartnerPayoutsState {
  final int floatBalance;

  const PartnerPayoutsState({this.floatBalance = 250000});
}

class PartnerPayoutsInitialState extends PartnerPayoutsState {
  const PartnerPayoutsInitialState({super.floatBalance = 250000});
}

class PartnerPayoutsProcessingState extends PartnerPayoutsState {
  const PartnerPayoutsProcessingState({required super.floatBalance});
}

class PartnerPayoutsSuccessState extends PartnerPayoutsState {
  final String utr;
  final String successMessage;

  const PartnerPayoutsSuccessState({
    required super.floatBalance,
    required this.utr,
    required this.successMessage,
  });
}

class PartnerPayoutsErrorState extends PartnerPayoutsState {
  final String errorMessage;

  const PartnerPayoutsErrorState({
    required super.floatBalance,
    required this.errorMessage,
  });
}
