abstract class PartnerInspectionState {
  final bool touchScreen;
  final bool cameras;
  final bool battery;
  final bool biometrics;
  final bool bodyFlawless;
  final bool boxAndBill;
  final int calculatedOffer;

  const PartnerInspectionState({
    this.touchScreen = true,
    this.cameras = true,
    this.battery = true,
    this.biometrics = true,
    this.bodyFlawless = true,
    this.boxAndBill = true,
    this.calculatedOffer = 54000,
  });
}

class PartnerInspectionInitialState extends PartnerInspectionState {
  const PartnerInspectionInitialState()
      : super(
          touchScreen: true,
          cameras: true,
          battery: true,
          biometrics: true,
          bodyFlawless: true,
          boxAndBill: true,
          calculatedOffer: 54000,
        );
}

class PartnerInspectionUpdatedState extends PartnerInspectionState {
  const PartnerInspectionUpdatedState({
    required super.touchScreen,
    required super.cameras,
    required super.battery,
    required super.biometrics,
    required super.bodyFlawless,
    required super.boxAndBill,
    required super.calculatedOffer,
  });
}

class PartnerInspectionSubmittingState extends PartnerInspectionState {
  const PartnerInspectionSubmittingState({
    required super.touchScreen,
    required super.cameras,
    required super.battery,
    required super.biometrics,
    required super.bodyFlawless,
    required super.boxAndBill,
    required super.calculatedOffer,
  });
}

class PartnerInspectionSuccessState extends PartnerInspectionState {
  final String successMessage;

  const PartnerInspectionSuccessState({
    required super.touchScreen,
    required super.cameras,
    required super.battery,
    required super.biometrics,
    required super.bodyFlawless,
    required super.boxAndBill,
    required super.calculatedOffer,
    required this.successMessage,
  });
}
