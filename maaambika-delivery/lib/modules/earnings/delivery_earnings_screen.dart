import 'package:flutter/material.dart';

class DeliveryEarningsScreen extends StatefulWidget {
  const DeliveryEarningsScreen({super.key});

  @override
  State<DeliveryEarningsScreen> createState() => _DeliveryEarningsScreenState();
}

class _DeliveryEarningsScreenState extends State<DeliveryEarningsScreen> {
  int _selectedTab = 0; // 0: Earnings, 1: Payouts, 2: Incentives
  final String _selectedDate = '10 Oct 2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ── TABS: Earnings | Payouts | Incentives ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: Row(
              children: [
                _buildTab('Earnings', 0),
                _buildTab('Payouts', 1),
                _buildTab('Incentives', 2),
              ],
            ),
          ),

          // ── TAB BODY ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: _selectedTab == 0
                  ? _buildEarningsTab()
                  : _selectedTab == 1
                      ? _buildPayoutsTab()
                      : _buildIncentivesTab(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF059669) : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF059669) : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── EARNINGS TAB ──
  Widget _buildEarningsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── TOP EMERALD GREEN CARD ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF047857), Color(0xFF065F46), Color(0xFF064E3B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF065F46).withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        "Today's Net Earnings",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.info_outline_rounded, color: Colors.white60, size: 15),
                    ],
                  ),
                  // Date Dropdown Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 13),
                        const SizedBox(width: 5),
                        Text(
                          _selectedDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '₹1,800',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Icon(Icons.arrow_upward_rounded, color: Color(0xFF34D399), size: 15),
                          SizedBox(width: 3),
                          Text(
                            '+28% higher than yesterday',
                            style: TextStyle(
                              color: Color(0xFF34D399),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Mini Bar Chart
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(14, 0.4),
                      _buildBar(22, 0.6),
                      _buildBar(18, 0.5),
                      _buildBar(30, 0.8),
                      _buildBar(24, 0.65),
                      _buildBar(36, 1.0),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ── TWO ACCUMULATED & NEXT PAYOUT STAT CARDS ──
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF059669), size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Weekly Accumulated',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '₹7,040',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '88 total trips',
                      style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.account_balance_outlined, color: Color(0xFF2563EB), size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Next Payout (Est.)',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '₹2,500',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'by 15 Oct 2026',
                      style: TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        // ── EARNINGS BREAKDOWN (TODAY) ──
        const Text(
          'Earnings Breakdown (Today)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        _buildBreakdownTile(
          icon: Icons.inventory_2_outlined,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF2563EB),
          title: 'Base Delivery Pay',
          subtitle: '5 deliveries × ₹250',
          amount: '₹1,250',
        ),
        _buildBreakdownTile(
          icon: Icons.bolt_rounded,
          iconBg: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFD97706),
          title: 'Peak Hour Bonus',
          subtitle: '2 deliveries (6–9 PM)',
          amount: '₹300',
        ),
        _buildBreakdownTile(
          icon: Icons.star_outline_rounded,
          iconBg: const Color(0xFFFFFBEB),
          iconColor: const Color(0xFFF59E0B),
          title: 'Customer Rating Bonus',
          subtitle: 'Maintained 4.5+ rating',
          amount: '₹150',
        ),
        _buildBreakdownTile(
          icon: Icons.emoji_events_outlined,
          iconBg: const Color(0xFFFEF2F2),
          iconColor: const Color(0xFFEF4444),
          title: 'Attendance Bonus',
          subtitle: 'Online for 8+ hours',
          amount: '₹100',
        ),

        const SizedBox(height: 22),

        // ── RECENT PAYOUTS ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Payouts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            InkWell(
              onTap: () => setState(() => _selectedTab = 1),
              child: const Text(
                'View All',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildPayoutTile(
          bank: 'HDFC Bank',
          date: '05 Oct 2026',
          amount: '₹5,200',
          status: 'Paid',
          logoColor: const Color(0xFFDC2626),
        ),
        _buildPayoutTile(
          bank: 'PhonePe',
          date: '28 Sep 2026',
          amount: '₹4,800',
          status: 'Paid',
          logoColor: const Color(0xFF7C3AED),
        ),

        const SizedBox(height: 16),
        // Instant Payout Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Instant Payout request of ₹1,800 submitted to linked bank account!'),
                  backgroundColor: Color(0xFF059669),
                ),
              );
            },
            icon: const Icon(Icons.flash_on_rounded, size: 18, color: Colors.white),
            label: const Text(
              'Withdraw Today\'s Earnings (Instant Payout)',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBar(double height, double opacity) {
    return Container(
      width: 6,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
        color: const Color(0xFF34D399).withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildBreakdownTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 18),
        ],
      ),
    );
  }

  Widget _buildPayoutTile({
    required String bank,
    required String date,
    required String amount,
    required String status,
    required Color logoColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: logoColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.account_balance, color: logoColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bank,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Color(0xFF15803D), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 18),
        ],
      ),
    );
  }

  // ── PAYOUTS TAB ──
  Widget _buildPayoutsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Available Balance for Payout', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              const SizedBox(height: 4),
              const Text('₹2,450.00', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(Icons.account_balance, color: Color(0xFF059669), size: 18),
                  SizedBox(width: 8),
                  Text('HDFC Bank ••••• 8491 (Primary)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payout initiated to HDFC Bank!'), backgroundColor: Color(0xFF059669)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Transfer to Bank Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Payout History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const SizedBox(height: 12),
        _buildPayoutTile(bank: 'HDFC Bank', date: '05 Oct 2026', amount: '₹5,200', status: 'Paid', logoColor: const Color(0xFFDC2626)),
        _buildPayoutTile(bank: 'PhonePe UPI', date: '28 Sep 2026', amount: '₹4,800', status: 'Paid', logoColor: const Color(0xFF7C3AED)),
        _buildPayoutTile(bank: 'HDFC Bank', date: '21 Sep 2026', amount: '₹6,150', status: 'Paid', logoColor: const Color(0xFFDC2626)),
        _buildPayoutTile(bank: 'HDFC Bank', date: '14 Sep 2026', amount: '₹5,400', status: 'Paid', logoColor: const Color(0xFFDC2626)),
      ],
    );
  }

  // ── INCENTIVES TAB ──
  Widget _buildIncentivesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFCD34D)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.emoji_events_rounded, color: Color(0xFFB45309), size: 24),
                  SizedBox(width: 8),
                  Text('Daily Target: 6 Deliveries', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF78350F))),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Complete 6 deliveries today to unlock ₹400 bonus milestone.', style: TextStyle(fontSize: 12, color: Color(0xFF92400E))),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const LinearProgressIndicator(
                  value: 0.83,
                  minHeight: 8,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD97706)),
                ),
              ),
              const SizedBox(height: 6),
              const Text('5 of 6 trips completed (1 trip left)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Active Milestone Challenges', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const SizedBox(height: 12),
        _buildChallengeCard('Weekend Warrior', 'Complete 25 deliveries from Fri–Sun', '₹1,500 Bonus', '18/25 done', 0.72),
        _buildChallengeCard('Rain Surge Shield', 'Deliver during active monsoon surge alerts', '₹80 Extra/trip', 'Active Now', 1.0),
        _buildChallengeCard('5-Star Customer Champion', 'Maintain 4.8+ rating over 50 consecutive orders', '₹1,000 Reward', '4.9 ⭐', 0.98),
      ],
    );
  }

  Widget _buildChallengeCard(String title, String desc, String reward, String progressText, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(8)),
                child: Text(reward, style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
            ),
          ),
          const SizedBox(height: 4),
          Text(progressText, style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
