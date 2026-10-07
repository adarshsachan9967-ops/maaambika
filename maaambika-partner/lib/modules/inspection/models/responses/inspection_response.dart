class InspectionResponse {
  final bool success;
  final String? inspectionId;
  final int finalOffer;
  final String? message;

  const InspectionResponse({
    required this.success,
    this.inspectionId,
    required this.finalOffer,
    this.message,
  });

  factory InspectionResponse.fromJson(Map<String, dynamic> json) {
    return InspectionResponse(
      success: json['success'] == true,
      inspectionId: json['inspectionId']?.toString(),
      finalOffer: (json['finalOffer'] as num?)?.toInt() ?? 0,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (inspectionId != null) 'inspectionId': inspectionId,
      'finalOffer': finalOffer,
      if (message != null) 'message': message,
    };
  }
}
