import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../data/fallback/fallback_partner_data.dart';
import '../models/requests/fetch_dashboard_request.dart';
import '../models/responses/dashboard_response.dart';
import '../repositories/dashboard_repository.dart';
import 'partner_dashboard_event.dart';
import 'partner_dashboard_state.dart';

class PartnerDashboardBloc extends Bloc<PartnerDashboardEvent, PartnerDashboardState> {
  final DashboardRepository _dashboardRepository;

  PartnerDashboardBloc({DashboardRepository? dashboardRepository})
      : _dashboardRepository = dashboardRepository ?? DashboardRepositoryImpl(),
        super(const PartnerDashboardInitialState()) {
    on<LoadPartnerDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadPartnerDashboardEvent event,
    Emitter<PartnerDashboardState> emit,
  ) async {
    if (!event.isRefresh && state is! PartnerDashboardLoadedState) {
      emit(const PartnerDashboardLoadingState());
    }

    try {
      final response = await _dashboardRepository.getDashboard(
        const FetchDashboardRequest(),
      );

      if (response.statusCode == 200 && response.data != null && response.data is Map) {
        final parsed = DashboardResponse.fromJson(Map<String, dynamic>.from(response.data as Map));
        emit(
          PartnerDashboardLoadedState(
            stats: parsed.stats,
            pendingQueue: parsed.pendingQueue.isNotEmpty
                ? parsed.pendingQueue
                : FallbackPartnerData.pendingQueue,
            isFromFallback: false,
          ),
        );
      } else {
        emit(
          const PartnerDashboardLoadedState(
            stats: FallbackPartnerData.stats,
            pendingQueue: FallbackPartnerData.pendingQueue,
            isFromFallback: true,
          ),
        );
      }
    } catch (e) {
      appLog("PartnerDashboardBloc error (falling back to local): $e");
      emit(
        const PartnerDashboardLoadedState(
          stats: FallbackPartnerData.stats,
          pendingQueue: FallbackPartnerData.pendingQueue,
          isFromFallback: true,
        ),
      );
    }
  }
}
