class AdminOrder {
  final String id;
  final String type;
  final String customer;
  final String phone;
  final String device;
  final String quote;
  final String assignedRider;
  final String status;
  final String date;
  final String hub;

  const AdminOrder({
    required this.id,
    required this.type,
    required this.customer,
    required this.phone,
    required this.device,
    required this.quote,
    required this.assignedRider,
    required this.status,
    required this.date,
    required this.hub,
  });

  factory AdminOrder.fromJson(Map<String, dynamic> json) {
    return AdminOrder(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Sell Order',
      customer: json['customer']?.toString() ?? 'Customer',
      phone: json['phone']?.toString() ?? '',
      device: json['device']?.toString() ?? 'Device',
      quote: json['quote']?.toString() ?? '₹0',
      assignedRider: json['assignedRider']?.toString() ?? 'Unassigned',
      status: json['status']?.toString() ?? 'Pending',
      date: json['date']?.toString() ?? '',
      hub: json['hub']?.toString() ?? 'Central Hub',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'customer': customer,
      'phone': phone,
      'device': device,
      'quote': quote,
      'assignedRider': assignedRider,
      'status': status,
      'date': date,
      'hub': hub,
    };
  }

  AdminOrder copyWith({
    String? id,
    String? type,
    String? customer,
    String? phone,
    String? device,
    String? quote,
    String? assignedRider,
    String? status,
    String? date,
    String? hub,
  }) {
    return AdminOrder(
      id: id ?? this.id,
      type: type ?? this.type,
      customer: customer ?? this.customer,
      phone: phone ?? this.phone,
      device: device ?? this.device,
      quote: quote ?? this.quote,
      assignedRider: assignedRider ?? this.assignedRider,
      status: status ?? this.status,
      date: date ?? this.date,
      hub: hub ?? this.hub,
    );
  }
}
