import '../../../../data/models/hotspot.dart';

class HubsResponse {
  final bool success;
  final List<DropOffHub> hubs;

  HubsResponse({
    required this.success,
    required this.hubs,
  });

  factory HubsResponse.fromJson(dynamic json) {
    if (json is List) {
      return HubsResponse(
        success: true,
        hubs: json
            .map((i) => DropOffHub.fromMap(i as Map<String, dynamic>))
            .toList(),
      );
    }
    if (json is Map<String, dynamic>) {
      final list = (json['data'] ?? json['hubs']) as List<dynamic>?;
      return HubsResponse(
        success: json['success'] as bool? ?? true,
        hubs: list
                ?.map((i) => DropOffHub.fromMap(i as Map<String, dynamic>))
                .toList() ??
            [],
      );
    }
    return HubsResponse(success: false, hubs: []);
  }
}
