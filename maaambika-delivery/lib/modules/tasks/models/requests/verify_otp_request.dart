class VerifyOtpRequest {
  final String taskId;
  final String otp;

  const VerifyOtpRequest({
    required this.taskId,
    required this.otp,
  });

  Map<String, dynamic> toData() {
    return {
      'taskId': taskId,
      'otp': otp,
    };
  }
}
