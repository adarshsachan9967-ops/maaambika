import 'package:flutter/material.dart';
import '../models/partner_order.dart';
import '../models/partner_stats.dart';
import '../models/store_kyc.dart';

class FallbackPartnerData {
  static const PartnerStats stats = PartnerStats(
    todayVolume: 48250,
    growthVsYesterday: 18.4,
    devicesLiquidated: 7,
    floatBalance: 250000,
    commissionEarned: 5790,
  );

  static const StoreKYC store = StoreKYC(
    storeName: 'TechWorld Hub',
    gstin: '07AAAAA0000A1Z5',
    address: 'Karol Bagh Main Market, New Delhi',
    tier: 'Gold Tier',
    isVerified: true,
    operatingHours: '10:00 AM - 08:30 PM (Mon - Sun)',
  );

  static const List<PartnerOrder> orders = [
    PartnerOrder(
      id: 'ORD-99120',
      device: 'Samsung Galaxy S23 Ultra',
      seller: 'Rajesh Gupta',
      price: '₹52,000',
      status: 'Arrived at Store',
      statusColor: Color(0xFF059669),
    ),
    PartnerOrder(
      id: 'ORD-99084',
      device: 'Sony Alpha A7 III Body',
      seller: 'Vikramaditya Rao',
      price: '₹84,000',
      status: 'Inspection In-Progress',
      statusColor: Color(0xFF2563EB),
    ),
    PartnerOrder(
      id: 'ORD-98912',
      device: 'iPad Pro 11" M2 128GB',
      seller: 'Neha Chawla',
      price: '₹44,500',
      status: 'Instant Payout Transferred',
      statusColor: Color(0xFF6B7280),
    ),
  ];

  static const List<Map<String, String>> pendingQueue = [
    {
      'model': 'iPhone 14 Pro 128GB',
      'customer': 'Customer: Karan Verma',
      'quote': 'Quoted: ₹54,000',
      'status': 'Awaiting Physical QA',
    },
    {
      'model': 'MacBook Air M2 256GB',
      'customer': 'Customer: Priya Sharma',
      'quote': 'Quoted: ₹68,500',
      'status': 'Diagnostic Ready',
    },
  ];
}
