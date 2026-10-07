class UpdateProfileRequest {
  final String storeName;
  final String operatingHours;

  const UpdateProfileRequest({
    required this.storeName,
    required this.operatingHours,
  });

  Map<String, dynamic> toData() {
    return {
      'storeName': storeName,
      'operatingHours': operatingHours,
    };
  }
}
