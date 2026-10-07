class PromoCoupon {
  final String code;
  final String description;
  final String usage;
  final String status;

  const PromoCoupon({
    required this.code,
    required this.description,
    required this.usage,
    required this.status,
  });

  factory PromoCoupon.fromJson(Map<String, dynamic> json) {
    return PromoCoupon(
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      usage: json['usage']?.toString() ?? 'Used 0 times',
      status: json['status']?.toString() ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'description': description,
      'usage': usage,
      'status': status,
    };
  }

  PromoCoupon copyWith({
    String? code,
    String? description,
    String? usage,
    String? status,
  }) {
    return PromoCoupon(
      code: code ?? this.code,
      description: description ?? this.description,
      usage: usage ?? this.usage,
      status: status ?? this.status,
    );
  }
}
