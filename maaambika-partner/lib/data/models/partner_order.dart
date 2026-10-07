import 'package:flutter/material.dart';

class PartnerOrder {
  final String id;
  final String device;
  final String seller;
  final String price;
  final String status;
  final Color statusColor;

  const PartnerOrder({
    required this.id,
    required this.device,
    required this.seller,
    required this.price,
    required this.status,
    required this.statusColor,
  });

  factory PartnerOrder.fromJson(Map<String, dynamic> json) {
    return PartnerOrder(
      id: json['id']?.toString() ?? '',
      device: json['device']?.toString() ?? '',
      seller: json['seller']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusColor: json['statusColor'] is Color
          ? json['statusColor']
          : const Color(0xFF2563EB),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'device': device,
    'seller': seller,
    'price': price,
    'status': status,
  };

  PartnerOrder copyWith({
    String? id,
    String? device,
    String? seller,
    String? price,
    String? status,
    Color? statusColor,
  }) {
    return PartnerOrder(
      id: id ?? this.id,
      device: device ?? this.device,
      seller: seller ?? this.seller,
      price: price ?? this.price,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
    );
  }
}
