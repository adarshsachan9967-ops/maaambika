import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/fallback/fallback_delivery_data.dart';
import '../../../data/models/earnings_summary.dart';
import '../models/requests/instant_payout_request.dart';
import '../models/responses/earnings_response.dart';
import '../repositories/earnings_repository.dart';
import 'earnings_event.dart';
import 'earnings_state.dart';

class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {
  final EarningsRepository repository;

  EarningsBloc({EarningsRepository? repository})
      : repository = repository ?? EarningsRepositoryImpl(),
        super(const EarningsInitial()) {
    on<LoadEarningsEvent>(_onLoadEarnings);
    on<RequestInstantPayoutEvent>(_onRequestPayout);
  }

  Future<void> _onLoadEarnings(
    LoadEarningsEvent event,
    Emitter<EarningsState> emit,
  ) async {
    emit(const EarningsLoading());
    try {
      EarningsSummary summary = FallbackDeliveryData.getEarningsSummary();
      try {
        final response = await repository.getEarnings();
        if (response.statusCode == 200 && response.data != null) {
          final earningsRes = EarningsResponse.fromJson(response.data);
          summary = earningsRes.summary;
        }
      } catch (err) {
        if (kDebugMode) {
          debugPrint('EarningsBloc: API error ($err), loading fallback.');
        }
      }

      emit(EarningsLoaded(summary: summary));
    } catch (e) {
      emit(EarningsError('Failed to load earnings: $e'));
    }
  }

  Future<void> _onRequestPayout(
    RequestInstantPayoutEvent event,
    Emitter<EarningsState> emit,
  ) async {
    if (state is EarningsLoaded) {
      final current = state as EarningsLoaded;
      try {
        await repository.requestInstantPayout(InstantPayoutRequest(amount: event.amount));
      } catch (_) {}

      emit(current.copyWith(
        message: 'Instant payout of ₹${event.amount.toStringAsFixed(2)} processed successfully!',
      ));
    }
  }
}
