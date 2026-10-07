import 'package:flutter/material.dart';

class DeliveryTask {
  final String id;
  final String type;
  final String customer;
  final String phone;
  final String address;
  final String distance;
  final String device;
  final String condition;
  final String payoutToCustomer;
  final String feeEarned;
  final String otp;
  String status;
  final String timeSlot;
  List<bool> checks;

  DeliveryTask({
    required this.id,
    required this.type,
    required this.customer,
    required this.phone,
    required this.address,
    required this.distance,
    required this.device,
    required this.condition,
    required this.payoutToCustomer,
    required this.feeEarned,
    required this.otp,
    required this.status,
    required this.timeSlot,
    required this.checks,
  });

  bool get isDelivered => status == 'Delivered';
  bool get isInTransit => status == 'In Transit';
  bool get isAssigned => status == 'Assigned';
  bool get allChecksCompleted => checks.isNotEmpty && checks.every((c) => c);

  Color get statusBadgeColor {
    if (isDelivered) return const Color(0xFF059669);
    if (isInTransit) return const Color(0xFFD97706);
    return const Color(0xFF2563EB);
  }

  factory DeliveryTask.fromMap(Map<String, dynamic> map) {
    return DeliveryTask(
      id: map['id'] as String? ?? '',
      type: map['type'] as String? ?? '',
      customer: map['customer'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      distance: map['distance'] as String? ?? '',
      device: map['device'] as String? ?? '',
      condition: map['condition'] as String? ?? '',
      payoutToCustomer: map['payoutToCustomer'] as String? ?? '',
      feeEarned: map['feeEarned'] as String? ?? '',
      otp: map['otp'] as String? ?? '',
      status: map['status'] as String? ?? 'Assigned',
      timeSlot: map['timeSlot'] as String? ?? '',
      checks: (map['checks'] as List<dynamic>?)?.map((e) => e as bool).toList() ??
          [false, false, false, false],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'customer': customer,
      'phone': phone,
      'address': address,
      'distance': distance,
      'device': device,
      'condition': condition,
      'payoutToCustomer': payoutToCustomer,
      'feeEarned': feeEarned,
      'otp': otp,
      'status': status,
      'timeSlot': timeSlot,
      'checks': checks,
    };
  }

  DeliveryTask copyWith({
    String? id,
    String? type,
    String? customer,
    String? phone,
    String? address,
    String? distance,
    String? device,
    String? condition,
    String? payoutToCustomer,
    String? feeEarned,
    String? otp,
    String? status,
    String? timeSlot,
    List<bool>? checks,
  }) {
    return DeliveryTask(
      id: id ?? this.id,
      type: type ?? this.type,
      customer: customer ?? this.customer,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      distance: distance ?? this.distance,
      device: device ?? this.device,
      condition: condition ?? this.condition,
      payoutToCustomer: payoutToCustomer ?? this.payoutToCustomer,
      feeEarned: feeEarned ?? this.feeEarned,
      otp: otp ?? this.otp,
      status: status ?? this.status,
      timeSlot: timeSlot ?? this.timeSlot,
      checks: checks ?? List<bool>.from(this.checks),
    );
  }
}
