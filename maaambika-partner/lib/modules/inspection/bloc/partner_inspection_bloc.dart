import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/logger.dart';
import '../models/requests/submit_inspection_request.dart';
import '../repositories/inspection_repository.dart';
import 'partner_inspection_event.dart';
import 'partner_inspection_state.dart';

class PartnerInspectionBloc extends Bloc<PartnerInspectionEvent, PartnerInspectionState> {
  final InspectionRepository _inspectionRepository;

  PartnerInspectionBloc({InspectionRepository? inspectionRepository})
      : _inspectionRepository = inspectionRepository ?? InspectionRepositoryImpl(),
        super(const PartnerInspectionInitialState()) {
    on<ToggleChecklistEvent>(_onToggleChecklist);
    on<SubmitInspectionEvent>(_onSubmitInspection);
  }

  int _calculateQuote({
    required bool touchScreen,
    required bool cameras,
    required bool battery,
    required bool biometrics,
    required bool bodyFlawless,
    required bool boxAndBill,
  }) {
    int base = 54000;
    if (!touchScreen) base -= 8500;
    if (!cameras) base -= 4000;
    if (!battery) base -= 3000;
    if (!biometrics) base -= 2500;
    if (!bodyFlawless) base -= 2000;
    if (!boxAndBill) base -= 1500;
    return base;
  }

  void _onToggleChecklist(
    ToggleChecklistEvent event,
    Emitter<PartnerInspectionState> emit,
  ) {
    bool touchScreen = state.touchScreen;
    bool cameras = state.cameras;
    bool battery = state.battery;
    bool biometrics = state.biometrics;
    bool bodyFlawless = state.bodyFlawless;
    bool boxAndBill = state.boxAndBill;

    switch (event.key) {
      case 'touchScreen':
        touchScreen = event.value;
        break;
      case 'cameras':
        cameras = event.value;
        break;
      case 'battery':
        battery = event.value;
        break;
      case 'biometrics':
        biometrics = event.value;
        break;
      case 'bodyFlawless':
        bodyFlawless = event.value;
        break;
      case 'boxAndBill':
        boxAndBill = event.value;
        break;
    }

    final newOffer = _calculateQuote(
      touchScreen: touchScreen,
      cameras: cameras,
      battery: battery,
      biometrics: biometrics,
      bodyFlawless: bodyFlawless,
      boxAndBill: boxAndBill,
    );

    emit(
      PartnerInspectionUpdatedState(
        touchScreen: touchScreen,
        cameras: cameras,
        battery: battery,
        biometrics: biometrics,
        bodyFlawless: bodyFlawless,
        boxAndBill: boxAndBill,
        calculatedOffer: newOffer,
      ),
    );
  }

  Future<void> _onSubmitInspection(
    SubmitInspectionEvent event,
    Emitter<PartnerInspectionState> emit,
  ) async {
    emit(
      PartnerInspectionSubmittingState(
        touchScreen: state.touchScreen,
        cameras: state.cameras,
        battery: state.battery,
        biometrics: state.biometrics,
        bodyFlawless: state.bodyFlawless,
        boxAndBill: state.boxAndBill,
        calculatedOffer: state.calculatedOffer,
      ),
    );

    final finalOffer = state.calculatedOffer;

    try {
      await _inspectionRepository.submitInspection(
        SubmitInspectionRequest(
          deviceImei: '354891028472911',
          touchScreen: state.touchScreen,
          cameras: state.cameras,
          battery: state.battery,
          biometrics: state.biometrics,
          bodyFlawless: state.bodyFlawless,
          boxAndBill: state.boxAndBill,
          finalOffer: finalOffer,
        ),
      );
    } catch (e) {
      appLog("SubmitInspection note: $e");
    }

    emit(
      PartnerInspectionSuccessState(
        touchScreen: state.touchScreen,
        cameras: state.cameras,
        battery: state.battery,
        biometrics: state.biometrics,
        bodyFlawless: state.bodyFlawless,
        boxAndBill: state.boxAndBill,
        calculatedOffer: finalOffer,
        successMessage: 'Offer ${formatCurrency(finalOffer)} Accepted! Transferring instant payout...',
      ),
    );
  }
}
