import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerSupportScreen extends StatefulWidget {
  const PartnerSupportScreen({super.key});

  @override
  State<PartnerSupportScreen> createState() => _PartnerSupportScreenState();
}

class _PartnerSupportScreenState extends State<PartnerSupportScreen> {
  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'TKT-P-001',
      'priority': 'High',
      'priorityColor': const Color(0xFFEF4444),
      'priorityBg': const Color(0xFFFEF2F2),
      'title': 'Payout not processed',
      'desc': 'My payout request of ₹28,500 submitted on Dec 12 is still pending.',
      'status': 'In Progress',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFEF3C7),
      'category': 'Payment',
      'date': '22 Dec 2024, 10:30 AM',
    },
    {
      'id': 'TKT-P-002',
      'priority': 'Medium',
      'priorityColor': const Color(0xFF2563EB),
      'priorityBg': const Color(0xFFEFF6FF),
      'title': 'Order not showing in dashboard',
      'desc': 'Order CSM-2024-007 was assigned to me but not visible in my orders list.',
      'status': 'Open',
      'statusColor': const Color(0xFF2563EB),
      'statusBg': const Color(0xFFEFF6FF),
      'category': 'Order',
      'date': '18 Dec 2024, 4:15 PM',
    },
    {
      'id': 'TKT-P-003',
      'priority': 'Low',
      'priorityColor': const Color(0xFF059669),
      'priorityBg': const Color(0xFFECFDF5),
      'title': 'Inspection app not working',
      'desc': 'Device inspection page is not loading images.',
      'status': 'Resolved',
      'statusColor': const Color(0xFF059669),
      'statusBg': const Color(0xFFECFDF5),
      'category': 'Technical',
      'date': '15 Dec 2024, 1:20 PM',
    },
  ];

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How are payouts processed?',
      'a': 'Payouts are automatically credited to your registered bank account or UPI every Wednesday. You can also use Instant Payout at any time from your Payouts tab.'
    },
    {
      'q': 'Why is my order not visible?',
      'a': 'Orders are assigned based on store distance and device category. If an order was accepted, pull down on your Orders screen to refresh live state.'
    },
    {
      'q': 'How to complete device inspection?',
      'a': 'Open the order and tap "Start Inspection". Follow the 4-step checklist: screen test, body examination, camera check, and battery health verification.'
    },
    {
      'q': 'What happens if a customer cancels?',
      'a': 'If cancellation occurs after inspection or transit dispatch, partner inspection fees and fuel costs are reimbursed within 24 hours.'
    },
  ];

  void _callSupport() async {
    final uri = Uri.parse('tel:+918260120467');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showRaiseTicketModal() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String category = 'Payment';

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
                    const Text('Raise Support Ticket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  items: ['Payment', 'Order', 'Technical', 'Store Verification', 'Commission']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setMState(() => category = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Subject / Issue Title', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'Describe the issue...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.trim().isEmpty) return;
                      setState(() {
                        _tickets.insert(0, {
                          'id': 'TKT-P-00${_tickets.length + 1}',
                          'priority': 'Medium',
                          'priorityColor': const Color(0xFF2563EB),
                          'priorityBg': const Color(0xFFEFF6FF),
                          'title': titleController.text.trim(),
                          'desc': descController.text.trim(),
                          'status': 'Open',
                          'statusColor': const Color(0xFF2563EB),
                          'statusBg': const Color(0xFFEFF6FF),
                          'category': category,
                          'date': 'Just now',
                        });
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Support ticket raised! Partner representative assigned.'), backgroundColor: Color(0xFF059669)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Submit Ticket', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Support',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5),
            ),
            const SizedBox(height: 2),
            const Text(
              'Get help, raise a ticket or contact our support team',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),

            // ── 4 QUICK ACTIONS ──
            Row(
              children: [
                _buildActionCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  iconColor: const Color(0xFF059669),
                  iconBg: const Color(0xFFECFDF5),
                  title: 'Chat with\nSupport',
                  subtitle: 'Get instant help',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Live Partner Support Chat initiated.'), backgroundColor: Color(0xFF059669)),
                    );
                  },
                ),
                const SizedBox(width: 10),
                _buildActionCard(
                  icon: Icons.phone_in_talk_rounded,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFEFF6FF),
                  title: 'Call\nSupport',
                  subtitle: 'Speak to our team',
                  onTap: _callSupport,
                ),
                const SizedBox(width: 10),
                _buildActionCard(
                  icon: Icons.post_add_rounded,
                  iconColor: const Color(0xFFDC2626),
                  iconBg: const Color(0xFFFEF2F2),
                  title: 'Raise a\nTicket',
                  subtitle: 'Report an issue',
                  onTap: _showRaiseTicketModal,
                ),
                const SizedBox(width: 10),
                _buildActionCard(
                  icon: Icons.menu_book_rounded,
                  iconColor: const Color(0xFF7C3AED),
                  iconBg: const Color(0xFFF5F3FF),
                  title: 'Help\nCenter',
                  subtitle: 'Find answers',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── SUPPORT HOURS BANNER ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.headset_mic_rounded, color: Color(0xFF059669), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Support Hours', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF065F46))),
                        Text('Mon - Sun, 9:00 AM - 8:00 PM', style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Color(0xFF10B981), size: 8),
                      SizedBox(width: 4),
                      Text('We\'re Online', style: TextStyle(color: Color(0xFF065F46), fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ── MY TICKETS HEADER ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('My Tickets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                InkWell(
                  onTap: _showRaiseTicketModal,
                  child: const Text('+ Raise Ticket', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── TICKETS ──
            ..._tickets.map((t) => _buildTicketCard(t)),

            const SizedBox(height: 22),

            // ── FAQS ──
            const Text('Frequently Asked Questions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 10),
            ..._faqs.map((f) => _buildFaqTile(f['q']!, f['a']!)),

            const SizedBox(height: 18),
            // Contact Phone Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.phone_in_talk_rounded, color: Color(0xFF059669), size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Direct Partner Helpline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                        Text('+91 8260120467', style: TextStyle(fontSize: 12, color: Color(0xFF059669), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _callSupport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Call Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.2), textAlign: TextAlign.center),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(t['id'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: t['priorityBg'] as Color, borderRadius: BorderRadius.circular(6)),
                    child: Text(t['priority'] as String, style: TextStyle(color: t['priorityColor'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: t['statusBg'] as Color, borderRadius: BorderRadius.circular(6)),
                child: Text(t['status'] as String, style: TextStyle(color: t['statusColor'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(t['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 3),
          Text(t['desc'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                child: Text(t['category'] as String, style: const TextStyle(fontSize: 10, color: Color(0xFF475569), fontWeight: FontWeight.w600)),
              ),
              Text(t['date'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        title: Text(question, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        children: [
          Text(answer, style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.4)),
        ],
      ),
    );
  }
}
