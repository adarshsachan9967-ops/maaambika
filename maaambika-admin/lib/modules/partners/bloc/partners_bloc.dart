import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../data/fallback/fallback_admin_data.dart';
import '../../../../data/models/partner_store.dart';
import '../models/requests/approve_kyc_request.dart';
import '../models/requests/fetch_partners_request.dart';
import '../models/responses/partners_response.dart';
import '../repositories/partners_repository.dart';
import 'partners_event.dart';
import 'partners_state.dart';

class PartnersBloc extends Bloc<PartnersEvent, PartnersState> {
  final PartnersRepository _partnersRepository;

  PartnersBloc({PartnersRepository? partnersRepository})
      : _partnersRepository = partnersRepository ?? PartnersRepositoryImpl(),
        super(const PartnersInitialState()) {
    on<LoadPartnersEvent>(_onLoadPartners);
    on<ApproveKycEvent>(_onApproveKyc);
  }

  Future<void> _onLoadPartners(
    LoadPartnersEvent event,
    Emitter<PartnersState> emit,
  ) async {
    if (!event.isRefresh && state is! PartnersLoadedState) {
      emit(const PartnersLoadingState());
    }

    try {
      final response = await _partnersRepository.getPartners(
        const FetchPartnersRequest(),
      );

      if (response.statusCode == 200 && response.data != null && response.data is Map) {
        final parsed = PartnersResponse.fromJson(Map<String, dynamic>.from(response.data as Map));
        emit(
          PartnersLoadedState(
            partners: parsed.partners.isNotEmpty
                ? parsed.partners
                : FallbackAdminData.defaultPartners,
            isFromFallback: parsed.partners.isEmpty,
          ),
        );
      } else {
        emit(
          PartnersLoadedState(
            partners: FallbackAdminData.defaultPartners,
            isFromFallback: true,
          ),
        );
      }
    } catch (e) {
      appLog("PartnersBloc error (falling back to local): $e");
      emit(
        PartnersLoadedState(
          partners: FallbackAdminData.defaultPartners,
          isFromFallback: true,
        ),
      );
    }
  }

  Future<void> _onApproveKyc(
    ApproveKycEvent event,
    Emitter<PartnersState> emit,
  ) async {
    List<PartnerStore> current = [];
    if (state is PartnersLoadedState) {
      current = (state as PartnersLoadedState).partners;
    } else {
      current = List.from(FallbackAdminData.defaultPartners);
    }

    final updated = current.map((p) {
      if (p.name == event.partnerName) {
        return p.copyWith(kyc: 'Approved', active: true);
      }
      return p;
    }).toList();

    emit(
      PartnersLoadedState(
        partners: updated,
        message: '${event.partnerName} is now approved & active!',
      ),
    );

    try {
      await _partnersRepository.approveKyc(
        ApproveKycRequest(partnerName: event.partnerName),
      );
    } catch (e) {
      appLog("ApproveKyc API sync note: $e");
    }
  }
}
