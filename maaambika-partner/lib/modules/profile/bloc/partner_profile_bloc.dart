import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/session_manager.dart';
import '../../../../data/fallback/fallback_partner_data.dart';
import '../models/responses/partner_profile_response.dart';
import '../repositories/partner_profile_repository.dart';
import 'partner_profile_event.dart';
import 'partner_profile_state.dart';

class PartnerProfileBloc extends Bloc<PartnerProfileEvent, PartnerProfileState> {
  final PartnerProfileRepository _profileRepository;

  PartnerProfileBloc({PartnerProfileRepository? profileRepository})
      : _profileRepository = profileRepository ?? PartnerProfileRepositoryImpl(),
        super(const PartnerProfileInitialState()) {
    on<LoadPartnerProfileEvent>(_onLoadProfile);
    on<LogoutPartnerEvent>(_onLogout);
  }

  Future<void> _onLoadProfile(
    LoadPartnerProfileEvent event,
    Emitter<PartnerProfileState> emit,
  ) async {
    if (!event.isRefresh && state is! PartnerProfileLoadedState) {
      emit(const PartnerProfileLoadingState());
    }

    try {
      final response = await _profileRepository.getProfile();

      if (response.statusCode == 200 && response.data != null && response.data is Map) {
        final parsed = PartnerProfileResponse.fromJson(Map<String, dynamic>.from(response.data as Map));
        emit(
          PartnerProfileLoadedState(
            store: parsed.store,
            isFromFallback: false,
          ),
        );
      } else {
        emit(
          const PartnerProfileLoadedState(
            store: FallbackPartnerData.store,
            isFromFallback: true,
          ),
        );
      }
    } catch (e) {
      appLog("PartnerProfileBloc error (falling back to local): $e");
      emit(
        const PartnerProfileLoadedState(
          store: FallbackPartnerData.store,
          isFromFallback: true,
        ),
      );
    }
  }

  Future<void> _onLogout(
    LogoutPartnerEvent event,
    Emitter<PartnerProfileState> emit,
  ) async {
    await SessionManager.forceLogout();
    emit(const PartnerProfileLoggedOutState());
  }
}
