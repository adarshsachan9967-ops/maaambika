class AuditActivity {
  final String title;
  final String description;
  final String time;
  final String type; // 'order', 'rider', 'payout', 'pricing'

  const AuditActivity({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });

  factory AuditActivity.fromJson(Map<String, dynamic> json) {
    return AuditActivity(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      type: json['type']?.toString() ?? 'order',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'time': time,
      'type': type,
    };
  }
}
