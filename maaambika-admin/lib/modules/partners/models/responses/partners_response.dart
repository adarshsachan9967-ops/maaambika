import '../../../../data/models/partner_store.dart';

class PartnersResponse {
  final bool success;
  final List<PartnerStore> partners;
  final String? message;

  const PartnersResponse({
    required this.success,
    required this.partners,
    this.message,
  });

  factory PartnersResponse.fromJson(Map<String, dynamic> json) {
    final list = <PartnerStore>[];
    if (json['data'] is List) {
      for (final item in json['data'] as List) {
        if (item is Map) {
          list.add(PartnerStore.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    } else if (json['partners'] is List) {
      for (final item in json['partners'] as List) {
        if (item is Map) {
          list.add(PartnerStore.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return PartnersResponse(
      success: json['success'] == true,
      partners: list,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'partners': partners.map((p) => p.toJson()).toList(),
      if (message != null) 'message': message,
    };
  }
}
