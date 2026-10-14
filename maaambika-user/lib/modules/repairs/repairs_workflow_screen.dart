import 'package:flutter/material.dart';
import '../../models/user_order.dart';
import '../../models/user_profile.dart';

class RepairsWorkflowScreen extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserOrder) onOrderCreated;

  const RepairsWorkflowScreen({
    super.key,
    required this.userProfile,
    required this.onOrderCreated,
  });

  @override
  State<RepairsWorkflowScreen> createState() => _RepairsWorkflowScreenState();
}

class _RepairsWorkflowScreenState extends State<RepairsWorkflowScreen> {
  int _selectedIssueIndex = 0;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _issueTypes = [
    {'title': 'Screen\nRepair', 'icon': Icons.phone_android_rounded, 'color': Color(0xFF6366F1), 'bg': Color(0xFFEEF2FF)},
    {'title': 'Battery\nReplacement', 'icon': Icons.battery_charging_full_rounded, 'color': Color(0xFF10B981), 'bg': Color(0xFFECFDF5)},
    {'title': 'Camera\nRepair', 'icon': Icons.camera_alt_rounded, 'color': Color(0xFFF59E0B), 'bg': Color(0xFFFFFBEB)},
    {'title': 'Charging Port\nRepair', 'icon': Icons.power_rounded, 'color': Color(0xFFEF4444), 'bg': Color(0xFFFEF2F2)},
    {'title': 'Audio & Mic\nRepair', 'icon': Icons.volume_up_rounded, 'color': Color(0xFF3B82F6), 'bg': Color(0xFFEFF6FF)},
    {'title': 'Water\nDamage', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF06B6D4), 'bg': Color(0xFFECFEFF)},
    {'title': 'Software\nIssues', 'icon': Icons.settings_rounded, 'color': Color(0xFF8B5CF6), 'bg': Color(0xFFF5F3FF)},
    {'title': 'Back Panel\nReplacement', 'icon': Icons.phonelink_setup_rounded, 'color': Color(0xFFF97316), 'bg': Color(0xFFFFF7ED)},
    {'title': 'Speaker\nRepair', 'icon': Icons.speaker_rounded, 'color': Color(0xFF10B981), 'bg': Color(0xFFECFDF5)},
    {'title': 'Other\nIssues', 'icon': Icons.more_horiz_rounded, 'color': Color(0xFF64748B), 'bg': Color(0xFFF1F5F9)},
  ];

  final List<Map<String, dynamic>> _popularRepairs = [
    {
      'device': 'iPhone 15 Pro',
      'service': 'Screen Replacement',
      'price': '₹8,499',
      'originalPrice': '₹11,999',
      'time': '30 mins',
      'image': 'assets/images/refurbished/iphone-15-pro.png',
    },
    {
      'device': 'Samsung S24',
      'service': 'Battery Replacement',
      'price': '₹3,499',
      'originalPrice': '₹5,999',
      'time': '45 mins',
      'image': 'assets/images/refurbished/galaxy-s24-ultra.png',
    },
    {
      'device': 'OnePlus 12',
      'service': 'Camera Repair',
      'price': '₹4,999',
      'originalPrice': '₹8,999',
      'time': '60 mins',
      'image': 'assets/images/refurbished/oneplus-12.png',
    },
  ];

  void _showBookRepairModal(String deviceName, String serviceName, String price) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    String selectedSlot = '10:00 AM - 1:00 PM';
    final addressCtrl = TextEditingController(text: 'Noida, Sector 62');
    final phoneCtrl = TextEditingController(text: widget.userProfile.phone.isNotEmpty ? widget.userProfile.phone : '9876543210');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setMState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Book Doorstep Repair', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.build_rounded, color: Color(0xFF6366F1), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$deviceName • $serviceName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E1B4B))),
                            Text('Estimated: $price (Includes 6 Months Warranty)', style: const TextStyle(fontSize: 11, color: Color(0xFF4338CA))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                TextField(controller: addressCtrl, decoration: InputDecoration(labelText: 'Doorstep Service Address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                const SizedBox(height: 10),
                TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: 'Contact Phone Number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                const SizedBox(height: 12),
                const Text('Select Time Slot', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: ['10:00 AM - 1:00 PM', '2:00 PM - 5:00 PM', '5:00 PM - 8:00 PM'].map((slot) {
                    final isSel = selectedSlot == slot;
                    return Expanded(
                      child: InkWell(
                        onTap: () => setMState(() => selectedSlot = slot),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFF6366F1) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSel ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            slot.split(' - ').first,
                            style: TextStyle(color: isSel ? Colors.white : const Color(0xFF334155), fontSize: 11, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final order = UserOrder.fromJson({
                        'id': 'rep-${DateTime.now().millisecondsSinceEpoch}',
                        'orderNumber': 'REP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                        'type': 'repair',
                        'device': '$deviceName ($serviceName)',
                        'amount': int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 4999,
                        'createdAt': '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        'status': 'Repair Scheduled',
                        'customerAddress': '${addressCtrl.text.trim().isEmpty ? "Registered Address" : addressCtrl.text.trim()} ($selectedSlot)',
                        'paymentMethod': 'Pay on Delivery / UPI',
                      });
                      widget.onOrderCreated(order);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Doorstep repair booked successfully for $deviceName! Order #${order.orderNumber}'),
                          backgroundColor: const Color(0xFF059669),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Confirm Doorstep Booking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── SEARCH BAR ──
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v.trim()),
                      decoration: const InputDecoration(
                        hintText: 'Search for repairs (e.g. screen, battery, camera...)',
                        hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const Icon(Icons.mic_none_rounded, color: Color(0xFF64748B), size: 20),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── HERO REPAIR BANNER ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFC7D2FE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'EXPERT • CERTIFIED • AFFORDABLE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4F46E5),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Broken Today, Fixed Tomorrow',
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Get Your Device\nRepaired by\nExpert Technicians',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1B4B),
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      _BannerBadge(icon: Icons.verified_rounded, label: 'Original Parts'),
                      SizedBox(width: 6),
                      _BannerBadge(icon: Icons.engineering_rounded, label: 'Skilled Techs'),
                      SizedBox(width: 6),
                      _BannerBadge(icon: Icons.speed_rounded, label: 'Same Day'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showBookRepairModal('Smartphone', 'Full Diagnostic & Repair', '₹1,999'),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                        label: const Text('Book a Repair', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.shield_outlined, color: Color(0xFF059669), size: 16),
                          SizedBox(width: 4),
                          Text('6 Months Warranty', style: TextStyle(color: Color(0xFF065F46), fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── SELECT ISSUE TYPE ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Issue Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                InkWell(
                  onTap: () {},
                  child: const Text('View All >', style: TextStyle(color: Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 8,
                childAspectRatio: 0.76,
              ),
              itemCount: _issueTypes.length,
              itemBuilder: (context, idx) {
                final item = _issueTypes[idx];
                final isSelected = _selectedIssueIndex == idx;
                return InkWell(
                  onTap: () {
                    setState(() => _selectedIssueIndex = idx);
                    _showBookRepairModal('Smartphone', item['title'].replaceAll('\n', ' '), '₹2,499');
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: item['bg'] as Color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: const Color(0xFF0F172A),
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 22),

            // ── POPULAR DEVICE REPAIRS ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Device Repairs',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                InkWell(
                  onTap: () {},
                  child: const Text('View All >', style: TextStyle(color: Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _popularRepairs.where((r) => _searchQuery.isEmpty || (r['device'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) || (r['service'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).map((r) {
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                              child: Image.asset(r['image'] as String, fit: BoxFit.contain),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r['device'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text(r['service'] as String, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(r['price'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            const SizedBox(width: 6),
                            Text(r['originalPrice'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), decoration: TextDecoration.lineThrough)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(6)),
                              child: Text('⏱ ${r['time']}', style: const TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            InkWell(
                              onTap: () => _showBookRepairModal(r['device'], r['service'], r['price']),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(color: Color(0xFF6366F1), shape: BoxShape.circle),
                                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // ── HOW REPAIR SERVICE WORKS ──
            const Text(
              'How Repair Service Works',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildProcessStep('1', 'Select Device\n& Issue', Icons.smartphone_rounded),
                _buildProcessArrow(),
                _buildProcessStep('2', 'Book a\nRepair', Icons.calendar_today_rounded),
                _buildProcessArrow(),
                _buildProcessStep('3', 'Technician\nVisit', Icons.person_pin_rounded),
                _buildProcessArrow(),
                _buildProcessStep('4', 'Get It\nFixed', Icons.verified_rounded),
              ],
            ),

            const SizedBox(height: 22),

            // ── SOCIAL PROOF FOOTER ──
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: Color(0xFF059669), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Trusted by 10,00,000+ Users', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF065F46))),
                        Text('Genuine Parts • Certified Technicians • 100% Secure', style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                      ],
                    ),
                  ),
                  Text('⭐ 4.8/5', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessStep(String num, String title, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF6366F1)),
            ),
            child: Icon(icon, color: const Color(0xFF6366F1), size: 18),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.1),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProcessArrow() {
    return const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF94A3B8));
  }
}

class _BannerBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BannerBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 11, color: const Color(0xFF6366F1)),
          const SizedBox(width: 3),
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
        ],
      ),
    );
  }
}
