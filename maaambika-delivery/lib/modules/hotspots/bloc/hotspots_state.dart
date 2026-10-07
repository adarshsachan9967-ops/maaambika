import '../../../data/models/hotspot.dart';

abstract class HotspotsState {
  const HotspotsState();
}

class HotspotsInitial extends HotspotsState {
  const HotspotsInitial();
}

class HotspotsLoading extends HotspotsState {
  const HotspotsLoading();
}

class HotspotsLoaded extends HotspotsState {
  final List<Hotspot> hotspots;
  final List<DropOffHub> hubs;

  const HotspotsLoaded({
    required this.hotspots,
    required this.hubs,
  });
}

class HotspotsError extends HotspotsState {
  final String errorMessage;
  const HotspotsError(this.errorMessage);
}
