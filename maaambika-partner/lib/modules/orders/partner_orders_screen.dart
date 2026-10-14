import 'package:flutter/material.dart';
import 'order_details_screen.dart';

class PartnerOrdersScreen extends StatefulWidget {
  const PartnerOrdersScreen({super.key});

  @override
  State<PartnerOrdersScreen> createState() => _PartnerOrdersScreenState();
}

class _PartnerOrdersScreenState extends State<PartnerOrdersScreen> {
  int _selectedFilter = 0; // 0: All, 1: New, 2: Accepted, 3: Pickup, 4: Inspection, 5: Completed
  String _searchQuery = '';

  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'CSM-2024-420',
      'type': 'Sell',
      'typeColor': const Color(0xFF7E22CE),
      'typeBg': const Color(0xFFF3E8FF),
      'device': 'Apple iPhone 16 Pro Max',
      'variant': '256GB • Desert Titanium',
      'customer': 'Adarsh deep Sachan',
      'phone': '9967853364',
      'address': 'Gaur City, Delhi NCR - 201009',
      'status': 'Under Inspection',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFEF3C7),
      'priceLabel': 'Estimated Payout',
      'price': '₹61,300',
      'time': 'Today, 9:00 AM',
      'image': 'assets/images/refurbished/iphone-15-pro.png',
      'imei': '352948102938472',
      'serial': 'C39DLSK9F4',
      'condition': 'Good',
      'accessories': 'Original Box, Charger',
      'purchaseDate': 'Mar 2024',
      'btn1': 'View Details',
      'btn2': 'Update Status',
      'btn3': 'Start Inspection',
      'btn3Color': const Color(0xFF059669),
    },
    {
      'id': 'CSM-2024-798',
      'type': 'Sell',
      'typeColor': const Color(0xFF7E22CE),
      'typeBg': const Color(0xFFF3E8FF),
      'device': 'Samsung Galaxy S24 Ultra',
      'variant': '256GB • Titanium Black',
      'customer': 'Rohit Sharma',
      'phone': '9876543210',
      'address': 'Noida, Uttar Pradesh - 201301',
      'status': 'Pickup Scheduled',
      'statusColor': const Color(0xFF2563EB),
      'statusBg': const Color(0xFFEFF6FF),
      'priceLabel': 'Estimated Payout',
      'price': '₹42,800',
      'time': 'Yesterday, 4:30 PM',
      'image': 'assets/images/refurbished/galaxy-s24-ultra.png',
      'imei': '358912048592182',
      'serial': 'R5CNA0392KL',
      'condition': 'Flawless',
      'accessories': 'Original Box, Cable',
      'purchaseDate': 'Jan 2024',
      'btn1': 'View Details',
      'btn2': 'Reschedule Pickup',
      'btn3': 'Mark as Picked Up',
      'btn3Color': const Color(0xFF2563EB),
    },
    {
      'id': 'CSM-2024-795',
      'type': 'Buy',
      'typeColor': const Color(0xFF059669),
      'typeBg': const Color(0xFFECFDF5),
      'device': 'MacBook Air M2',
      'variant': '8GB • 256GB • Space Grey',
      'customer': 'Priya Verma',
      'phone': '9876123456',
      'address': 'Ghaziabad, UP - 201002',
      'status': 'Completed',
      'statusColor': const Color(0xFF059669),
      'statusBg': const Color(0xFFDCFCE7),
      'priceLabel': 'Order Value',
      'price': '₹78,500',
      'time': '12 Oct 2026, 2:15 PM',
      'image': 'assets/images/refurbished/macbook-air-m2.png',
      'imei': 'C02G8392MD6R',
      'serial': 'C02G8392MD6R',
      'condition': 'Excellent',
      'accessories': 'MagSafe Charger, 30W Adapter',
      'purchaseDate': 'Aug 2023',
      'btn1': 'View Details',
      'btn2': 'Generate Invoice',
      'btn3': 'Completed',
      'btn3Color': const Color(0xFF059669),
    },
    {
      'id': 'CSM-2024-762',
      'type': 'Repair',
      'typeColor': const Color(0xFFEA580C),
      'typeBg': const Color(0xFFFFF7ED),
      'device': 'OnePlus 11',
      'variant': 'Screen Replacement',
      'customer': 'Amit Kumar',
      'phone': '9876001122',
      'address': 'Indirapuram, Ghaziabad - 201014',
      'status': 'In Progress',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFEF3C7),
      'priceLabel': 'Service Charge',
      'price': '₹4,500',
      'time': '11 Oct 2026, 11:20 AM',
      'image': 'assets/images/refurbished/oneplus-12.png',
      'imei': '864920193850193',
      'serial': 'OP11-893041',
      'condition': 'Broken Screen',
      'accessories': 'Device Only',
      'purchaseDate': 'Dec 2023',
      'btn1': 'View Details',
      'btn2': 'Update Status',
      'btn3': 'Mark as Completed',
      'btn3Color': const Color(0xFFEA580C),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _orders.where((o) {
      if (_selectedFilter == 1 && o['status'] != 'New') return false;
      if (_selectedFilter == 2 && o['status'] != 'Accepted') return false;
      if (_selectedFilter == 3 && o['status'] != 'Pickup Scheduled') return false;
      if (_selectedFilter == 4 && o['status'] != 'Under Inspection' && o['status'] != 'In Progress') return false;
      if (_selectedFilter == 5 && o['status'] != 'Completed') return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchDevice = (o['device'] as String).toLowerCase().contains(q);
        final matchCust = (o['customer'] as String).toLowerCase().contains(q);
        final matchId = (o['id'] as String).toLowerCase().contains(q);
        return matchDevice || matchCust || matchId;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ── HEADER WITH TITLE, SCAN QR & SEARCH ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Orders',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Manage and track all your store orders',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening QR Scanner...'), backgroundColor: Color(0xFF059669)),
                            );
                          },
                          icon: const Icon(Icons.qr_code_scanner_rounded, size: 16, color: Colors.white),
                          label: const Text('Scan QR', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.search_rounded, color: Color(0xFF334155), size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search Input Field
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setState(() => _searchQuery = v.trim()),
                          decoration: const InputDecoration(
                            hintText: 'Search by Order ID, Device or Customer...',
                            hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── FILTER CHIPS ROW (ALL (12), NEW (3), ACCEPTED (4), ETC.) ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 12, 0),
                  _buildFilterChip('New', 3, 1),
                  _buildFilterChip('Accepted', 4, 2),
                  _buildFilterChip('Pickup', 2, 3),
                  _buildFilterChip('Inspection', 2, 4),
                  _buildFilterChip('Completed', 1, 5),
                ],
              ),
            ),
          ),

          // ── ORDERS LIST ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(filtered[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, int index) {
    final isSelected = _selectedFilter == index;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = index),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF059669) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.25) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> o) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('#${o['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(color: o['typeBg'] as Color, borderRadius: BorderRadius.circular(6)),
                    child: Text(o['type'] as String, style: TextStyle(color: o['typeColor'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(color: o['statusBg'] as Color, borderRadius: BorderRadius.circular(6)),
                    child: Text(o['status'] as String, style: TextStyle(color: o['statusColor'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Text(o['time'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ],
          ),
          const SizedBox(height: 12),
          // Product Info
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Image.asset(o['image'] as String, fit: BoxFit.contain),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o['device'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(o['variant'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 12, color: Color(0xFF64748B)),
                        const SizedBox(width: 3),
                        Text(o['customer'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
                        const SizedBox(width: 6),
                        const Icon(Icons.phone_outlined, size: 12, color: Color(0xFF64748B)),
                        const SizedBox(width: 3),
                        Text(o['phone'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF64748B)),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(o['address'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => OrderDetailsScreen(order: o)));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(o['priceLabel'] as String, style: const TextStyle(fontSize: 9, color: Color(0xFF065F46))),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(o['price'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF059669))),
                          const SizedBox(width: 2),
                          const Icon(Icons.chevron_right, size: 16, color: Color(0xFF059669)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Action Buttons: View Details, Update Status, Primary Action
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => OrderDetailsScreen(order: o)));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('View Details', style: TextStyle(color: Color(0xFF334155), fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Status updated for #${o['id']}'), backgroundColor: const Color(0xFF059669)),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(o['btn2'] as String, style: const TextStyle(color: Color(0xFF334155), fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => OrderDetailsScreen(order: o)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: o['btn3Color'] as Color,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(o['btn3'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
