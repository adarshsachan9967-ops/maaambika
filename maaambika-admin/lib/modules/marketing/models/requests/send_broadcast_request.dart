class SendBroadcastRequest {
  final String title;
  final String body;
  final String targetAudience;

  const SendBroadcastRequest({
    required this.title,
    required this.body,
    this.targetAudience = 'all_users',
  });

  Map<String, dynamic> toData() {
    return {
      'title': title,
      'body': body,
      'targetAudience': targetAudience,
    };
  }
}
