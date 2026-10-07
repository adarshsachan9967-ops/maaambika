class PayoutResponse {
  final bool success;
  final String utr;
  final int newFloatBalance;
  final String? message;

  const PayoutResponse({
    required this.success,
    required this.utr,
    required this.newFloatBalance,
    this.message,
  });

  factory PayoutResponse.fromJson(Map<String, dynamic> json) {
    return PayoutResponse(
      success: json['success'] == true,
      utr: json['utr']?.toString() ?? 'MAP${DateTime.now().millisecondsSinceEpoch}',
      newFloatBalance: (json['newFloatBalance'] as num?)?.toInt() ?? 250000,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'utr': utr,
      'newFloatBalance': newFloatBalance,
      if (message != null) 'message': message,
    };
  }
}
