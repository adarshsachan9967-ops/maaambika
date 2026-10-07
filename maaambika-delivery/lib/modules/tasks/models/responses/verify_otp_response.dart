class VerifyOtpResponse {
  final bool verified;
  final String? message;

  VerifyOtpResponse({
    required this.verified,
    this.message,
  });

  factory VerifyOtpResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return VerifyOtpResponse(
        verified: json['verified'] == true || json['success'] == true,
        message: json['message'] as String?,
      );
    }
    return VerifyOtpResponse(verified: false);
  }
}
