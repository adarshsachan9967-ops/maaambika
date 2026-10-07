class PartnerStore {
  final String name;
  final String location;
  final String owner;
  final String margin;
  final String devicesSold;
  final String kyc;
  final bool active;

  const PartnerStore({
    required this.name,
    required this.location,
    required this.owner,
    required this.margin,
    required this.devicesSold,
    required this.kyc,
    required this.active,
  });

  factory PartnerStore.fromJson(Map<String, dynamic> json) {
    return PartnerStore(
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      owner: json['owner']?.toString() ?? '',
      margin: json['margin']?.toString() ?? '8.0%',
      devicesSold: json['devicesSold']?.toString() ?? '0 units',
      kyc: json['kyc']?.toString() ?? 'Pending',
      active: json['active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'owner': owner,
      'margin': margin,
      'devicesSold': devicesSold,
      'kyc': kyc,
      'active': active,
    };
  }

  PartnerStore copyWith({
    String? name,
    String? location,
    String? owner,
    String? margin,
    String? devicesSold,
    String? kyc,
    bool? active,
  }) {
    return PartnerStore(
      name: name ?? this.name,
      location: location ?? this.location,
      owner: owner ?? this.owner,
      margin: margin ?? this.margin,
      devicesSold: devicesSold ?? this.devicesSold,
      kyc: kyc ?? this.kyc,
      active: active ?? this.active,
    );
  }
}
