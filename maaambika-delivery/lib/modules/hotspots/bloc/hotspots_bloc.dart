import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/fallback/fallback_delivery_data.dart';
import '../../../data/models/hotspot.dart';
import '../models/responses/hotspots_response.dart';
import '../models/responses/hubs_response.dart';
import '../repositories/hotspots_repository.dart';
import 'hotspots_event.dart';
import 'hotspots_state.dart';

class HotspotsBloc extends Bloc<HotspotsEvent, HotspotsState> {
  final HotspotsRepository repository;

  HotspotsBloc({HotspotsRepository? repository})
      : repository = repository ?? HotspotsRepositoryImpl(),
        super(const HotspotsInitial()) {
    on<LoadHotspotsEvent>(_onLoadHotspots);
  }

  Future<void> _onLoadHotspots(
    LoadHotspotsEvent event,
    Emitter<HotspotsState> emit,
  ) async {
    emit(const HotspotsLoading());
    try {
      List<Hotspot> hotspots = [];
      List<DropOffHub> hubs = [];

      try {
        final resHotspots = await repository.getHotspots();
        if (resHotspots.statusCode == 200 && resHotspots.data != null) {
          final parsed = HotspotsResponse.fromJson(resHotspots.data);
          if (parsed.hotspots.isNotEmpty) {
            hotspots = parsed.hotspots;
          }
        }
      } catch (e) {
        if (kDebugMode) debugPrint('HotspotsBloc: error loading hotspots ($e)');
      }

      try {
        final resHubs = await repository.getHubs();
        if (resHubs.statusCode == 200 && resHubs.data != null) {
          final parsed = HubsResponse.fromJson(resHubs.data);
          if (parsed.hubs.isNotEmpty) {
            hubs = parsed.hubs;
          }
        }
      } catch (e) {
        if (kDebugMode) debugPrint('HotspotsBloc: error loading hubs ($e)');
      }

      if (hotspots.isEmpty) {
        hotspots = FallbackDeliveryData.getHotspots();
      }
      if (hubs.isEmpty) {
        hubs = FallbackDeliveryData.getHubs();
      }

      emit(HotspotsLoaded(hotspots: hotspots, hubs: hubs));
    } catch (e) {
      emit(HotspotsError('Failed to load hotspots: $e'));
    }
  }
}
