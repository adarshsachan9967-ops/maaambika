import '../../../../data/models/hotspot.dart';

class HotspotsResponse {
  final bool success;
  final List<Hotspot> hotspots;

  HotspotsResponse({
    required this.success,
    required this.hotspots,
  });

  factory HotspotsResponse.fromJson(dynamic json) {
    if (json is List) {
      return HotspotsResponse(
        success: true,
        hotspots: json
            .map((i) => Hotspot.fromMap(i as Map<String, dynamic>))
            .toList(),
      );
    }
    if (json is Map<String, dynamic>) {
      final list = (json['data'] ?? json['hotspots']) as List<dynamic>?;
      return HotspotsResponse(
        success: json['success'] as bool? ?? true,
        hotspots: list
                ?.map((i) => Hotspot.fromMap(i as Map<String, dynamic>))
                .toList() ??
            [],
      );
    }
    return HotspotsResponse(success: false, hotspots: []);
  }
}
