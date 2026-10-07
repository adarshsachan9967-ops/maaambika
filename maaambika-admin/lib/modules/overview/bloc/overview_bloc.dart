import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../data/fallback/fallback_admin_data.dart';
import '../models/requests/fetch_overview_request.dart';
import '../models/responses/overview_response.dart';
import '../repositories/overview_repository.dart';
import 'overview_event.dart';
import 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final OverviewRepository _overviewRepository;

  OverviewBloc({OverviewRepository? overviewRepository})
      : _overviewRepository = overviewRepository ?? OverviewRepositoryImpl(),
        super(const OverviewInitialState()) {
    on<LoadOverviewEvent>(_onLoadOverview);
  }

  Future<void> _onLoadOverview(
    LoadOverviewEvent event,
    Emitter<OverviewState> emit,
  ) async {
    if (!event.isRefresh && state is! OverviewLoadedState) {
      emit(const OverviewLoadingState());
    }

    try {
      final response = await _overviewRepository.getOverview(
        const FetchOverviewRequest(),
      );

      if (response.statusCode == 200 && response.data != null && response.data is Map) {
        final parsed = OverviewResponse.fromJson(Map<String, dynamic>.from(response.data as Map));
        emit(
          OverviewLoadedState(
            metrics: parsed.metrics,
            activities: parsed.activities.isNotEmpty
                ? parsed.activities
                : FallbackAdminData.defaultActivities,
            isFromFallback: false,
          ),
        );
      } else {
        // Fallback to offline defaults
        emit(
          OverviewLoadedState(
            metrics: FallbackAdminData.defaultMetrics,
            activities: FallbackAdminData.defaultActivities,
            isFromFallback: true,
          ),
        );
      }
    } catch (e) {
      appLog("OverviewBloc error (falling back to local): $e");
      emit(
        OverviewLoadedState(
          metrics: FallbackAdminData.defaultMetrics,
          activities: FallbackAdminData.defaultActivities,
          isFromFallback: true,
        ),
      );
    }
  }
}
