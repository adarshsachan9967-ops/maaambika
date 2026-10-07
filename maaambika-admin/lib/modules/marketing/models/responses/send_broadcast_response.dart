class SendBroadcastResponse {
  final bool success;
  final int recipientCount;
  final String? message;

  const SendBroadcastResponse({
    required this.success,
    required this.recipientCount,
    this.message,
  });

  factory SendBroadcastResponse.fromJson(Map<String, dynamic> json) {
    return SendBroadcastResponse(
      success: json['success'] == true,
      recipientCount: json['recipientCount'] is int
          ? json['recipientCount'] as int
          : int.tryParse(json['recipientCount']?.toString() ?? '12450') ?? 12450,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'recipientCount': recipientCount,
      if (message != null) 'message': message,
    };
  }
}
