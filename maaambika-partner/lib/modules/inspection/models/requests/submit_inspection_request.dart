class SubmitInspectionRequest {
  final String deviceImei;
  final bool touchScreen;
  final bool cameras;
  final bool battery;
  final bool biometrics;
  final bool bodyFlawless;
  final bool boxAndBill;
  final int finalOffer;

  const SubmitInspectionRequest({
    required this.deviceImei,
    required this.touchScreen,
    required this.cameras,
    required this.battery,
    required this.biometrics,
    required this.bodyFlawless,
    required this.boxAndBill,
    required this.finalOffer,
  });

  Map<String, dynamic> toData() {
    return {
      'deviceImei': deviceImei,
      'touchScreen': touchScreen,
      'cameras': cameras,
      'battery': battery,
      'biometrics': biometrics,
      'bodyFlawless': bodyFlawless,
      'boxAndBill': boxAndBill,
      'finalOffer': finalOffer,
    };
  }
}
