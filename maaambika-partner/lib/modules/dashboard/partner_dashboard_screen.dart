import 'package:flutter/material.dart';
import '../orders/order_details_screen.dart';

class PartnerDashboardScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const PartnerDashboardScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  int _selectedOrderFilter = 0; // 0: Recent, 1: Under Inspection, 2: Pickup Scheduled, 3: Completed

  final List<Map<String, dynamic>> _recentOrders = [
    {
      'id': 'CSM-2024-420',
      'type': 'Sell',
      'device': 'Apple iPhone 16 Pro Max',
      'variant': '256GB • Desert Titanium',
      'customer': 'Adarsh deep Sachan',
      'phone': '9967853364',
      'address': 'Gaur City, Delhi NCR - 201009',
      'status': 'Under Inspection',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFEF3C7),
      'price': '₹61,300',
      'time': 'Today, 9:00 AM',
      'image': 'assets/images/refurbished/iphone-15-pro.png',
      'imei': '352948102938472',
      'serial': 'C39DLSK9F4',
      'condition': 'Good',
      'accessories': 'Original Box, Charger',
      'purchaseDate': 'Mar 2024',
    },
    {
      'id': 'CSM-2024-798',
      'type': 'Sell',
      'device': 'Samsung Galaxy S24 Ultra',
      'variant': '256GB • Titanium Black',
      'customer': 'Rohit Sharma',
      'phone': '9876543210',
      'address': 'Noida, Uttar Pradesh - 201301',
      'status': 'Pickup Scheduled',
      'statusColor': const Color(0xFF2563EB),
      'statusBg': const Color(0xFFEFF6FF),
      'price': '₹42,800',
      'time': 'Yesterday, 4:30 PM',
      'image': 'assets/images/refurbished/galaxy-s24-ultra.png',
      'imei': '358912048592182',
      'serial': 'R5CNA0392KL',
      'condition': 'Flawless',
      'accessories': 'Original Box, Cable',
      'purchaseDate': 'Jan 2024',
    },
    {
      'id': 'CSM-2024-795',
      'type': 'Buy',
      'device': 'MacBook Air M2',
      'variant': '8GB • 256GB • Space Grey',
      'customer': 'Priya Verma',
      'phone': '9876123456',
      'address': 'Ghaziabad, UP - 201002',
      'status': 'Completed',
      'statusColor': const Color(0xFF059669),
      'statusBg': const Color(0xFFDCFCE7),
      'price': '₹78,500',
      'time': '12 Oct, 2:15 PM',
      'image': 'assets/images/refurbished/macbook-air-m2.png',
      'imei': 'C02G8392MD6R',
      'serial': 'C02G8392MD6R',
      'condition': 'Excellent',
      'accessories': 'MagSafe Charger, 30W Adapter',
      'purchaseDate': 'Aug 2023',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _recentOrders.where((o) {
      if (_selectedOrderFilter == 1) return o['status'] == 'Under Inspection';
      if (_selectedOrderFilter == 2) return o['status'] == 'Pickup Scheduled';
      if (_selectedOrderFilter == 3) return o['status'] == 'Completed';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. WELCOME HERO BANNER (MATCHING REFERENCE UI) ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFDE68A)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Welcome Back 👋',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFCD34D)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.trending_up_rounded, color: Color(0xFF059669), size: 14),
                            SizedBox(width: 4),
                            Text(
                              'More Orders, More Earnings',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Let\'s Grow \n',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextSpan(
                          text: 'Your Business',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFEA580C),
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Manage orders, inspections, payouts and everything in one place.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF78350F),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () => widget.onNavigate(3), // Navigate to payouts/insights
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                    label: const Text(
                      'View Insights',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF065F46),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 2. FOUR STAT METRIC CARDS ──
            Row(
              children: [
                _buildStatMetricCard(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: const Color(0xFF059669),
                  iconBg: const Color(0xFFECFDF5),
                  title: 'Total Earnings',
                  value: '₹3,85,000',
                  badgeText: '18.6% this week',
                  badgeColor: const Color(0xFF059669),
                  badgeIcon: Icons.check_circle_rounded,
                ),
                const SizedBox(width: 10),
                _buildStatMetricCard(
                  icon: Icons.inventory_2_outlined,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFEFF6FF),
                  title: 'Active Orders',
                  value: '12',
                  badgeText: '4 new today',
                  badgeColor: const Color(0xFF2563EB),
                  badgeIcon: Icons.circle,
                  onTap: () => widget.onNavigate(1),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatMetricCard(
                  icon: Icons.currency_rupee_rounded,
                  iconColor: const Color(0xFFEA580C),
                  iconBg: const Color(0xFFFFF7ED),
                  title: 'Total Commission',
                  value: '₹17,325',
                  badgeText: '15.3% this week',
                  badgeColor: const Color(0xFF059669),
                  badgeIcon: Icons.arrow_upward_rounded,
                ),
                const SizedBox(width: 10),
                _buildStatMetricCard(
                  icon: Icons.hourglass_top_rounded,
                  iconColor: const Color(0xFF7C3AED),
                  iconBg: const Color(0xFFF5F3FF),
                  title: 'Pending Payout',
                  value: '₹18,500',
                  badgeText: '2 payouts',
                  badgeColor: const Color(0xFF7C3AED),
                  badgeIcon: Icons.access_time_rounded,
                  onTap: () => widget.onNavigate(3),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // ── 3. QUICK ACTIONS HEADER ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                InkWell(
                  onTap: () => widget.onNavigate(1),
                  child: const Text(
                    'View All >',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── QUICK ACTIONS ROW (4 TILES) ──
            Row(
              children: [
                _buildQuickActionTile(
                  icon: Icons.shopping_cart_outlined,
                  iconColor: const Color(0xFF059669),
                  iconBg: const Color(0xFFECFDF5),
                  title: 'New Orders',
                  subtitle: 'View & Accept',
                  badgeCount: '2',
                  onTap: () => widget.onNavigate(1),
                ),
                const SizedBox(width: 10),
                _buildQuickActionTile(
                  icon: Icons.search_rounded,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFEFF6FF),
                  title: 'Inspection',
                  subtitle: 'Scan & Evaluate',
                  onTap: () => widget.onNavigate(2),
                ),
                const SizedBox(width: 10),
                _buildQuickActionTile(
                  icon: Icons.currency_rupee_rounded,
                  iconColor: const Color(0xFFEA580C),
                  iconBg: const Color(0xFFFFF7ED),
                  title: 'Wallet & Payouts',
                  subtitle: 'Check Balance',
                  onTap: () => widget.onNavigate(3),
                ),
                const SizedBox(width: 10),
                _buildQuickActionTile(
                  icon: Icons.headset_mic_outlined,
                  iconColor: const Color(0xFF7C3AED),
                  iconBg: const Color(0xFFF5F3FF),
                  title: 'Support',
                  subtitle: 'Raise a Ticket',
                  badgeCount: '1',
                  onTap: () => widget.onNavigate(4),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // ── 4. ORDER FILTER PILLS ──
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterPill('Recent Orders', 0),
                  _buildFilterPill('Under Inspection', 1),
                  _buildFilterPill('Pickup Scheduled', 2),
                  _buildFilterPill('Completed', 3),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── 5. LIVE RECENT ORDERS LIST ──
            ...filteredOrders.map(
              (o) => _buildOrderTile(context, o),
            ),

            const SizedBox(height: 14),

            // ── 6. PROMOTIONAL GET MORE ORDERS BANNER ──
            InkWell(
              onTap: () => widget.onNavigate(1),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDDD6FE)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.inventory_2_rounded, color: Color(0xFFEA580C), size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Get More Orders',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1B4B),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Keep your store online and increase your visibility',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF4C1D95),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF7C3AED), size: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    required String badgeText,
    required Color badgeColor,
    required IconData badgeIcon,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(badgeIcon, size: 11, color: badgeColor),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: badgeColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    String? badgeCount,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (badgeCount != null)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 17,
                  height: 17,
                  decoration: const BoxDecoration(
                    color: Color(0xFF059669),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      badgeCount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String title, int index) {
    final isSelected = _selectedOrderFilter == index;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedOrderFilter = index),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF059669) : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTile(BuildContext context, Map<String, dynamic> o) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => OrderDetailsScreen(order: o),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Image.asset(
                o['image'] as String,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const Icon(Icons.smartphone_rounded, color: Color(0xFF64748B), size: 28),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    o['device'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '#${o['id']}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: o['statusBg'] as Color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      o['status'] as String,
                      style: TextStyle(
                        color: o['statusColor'] as Color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  o['price'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF059669),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  o['time'] as String,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
          ],
        ),
      ),
    );
  }
}
