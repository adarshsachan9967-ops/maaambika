import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/user_order.dart';
import '../../models/user_profile.dart';

class UserProfileWidget extends StatelessWidget {
  final UserProfile profile;
  final List<UserOrder> orders;
  final Function(UserProfile) onProfileUpdate;
  final VoidCallback onLogout;
  final VoidCallback onNavigateToSell;
  final VoidCallback onNavigateToBuy;
  final VoidCallback? onNavigateToRepairs;

  const UserProfileWidget({
    super.key,
    required this.profile,
    required this.orders,
    required this.onProfileUpdate,
    required this.onLogout,
    required this.onNavigateToSell,
    required this.onNavigateToBuy,
    this.onNavigateToRepairs,
  });

  Future<void> _launchExternalUrl(BuildContext context, String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open: $urlString'),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching action: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = profile.name.isNotEmpty ? profile.name : 'Adarsh Sachan';
    final displayPhone = profile.phone.isNotEmpty ? profile.phone : '+91 98765 43210';
    final displayEmail = profile.email.isNotEmpty ? profile.email : 'adarshsachan@gmail.com';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. PROFILE HEADER CARD (MATCHING REFERENCE UI) ──
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                // Avatar with Edit Badge
                Stack(
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF0F172A),
                      ),
                      child: const ClipOval(
                        child: Icon(Icons.person, color: Colors.white, size: 36),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                // User Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displayPhone,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displayEmail,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 12),
                            SizedBox(width: 4),
                            Text('Verified User', style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showEditProfileModal(context),
                  icon: const Icon(Icons.edit_outlined, size: 13, color: Color(0xFF6366F1)),
                  label: const Text('Edit Profile', style: TextStyle(color: Color(0xFF6366F1), fontSize: 11, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFC7D2FE)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── 2. FOUR QUICK STAT METRICS ──
          Row(
            children: [
              _buildMetricTile(Icons.inventory_2_outlined, const Color(0xFF2563EB), const Color(0xFFEFF6FF), '${orders.length > 5 ? orders.length : 5}', 'My Orders'),
              const SizedBox(width: 8),
              _buildMetricTile(Icons.build_outlined, const Color(0xFF6366F1), const Color(0xFFEEF2FF), '2', 'Repair Bookings'),
              const SizedBox(width: 8),
              _buildMetricTile(Icons.currency_rupee_rounded, const Color(0xFF059669), const Color(0xFFECFDF5), '1', 'Devices Sold'),
              const SizedBox(width: 8),
              _buildMetricTile(Icons.favorite_border_rounded, const Color(0xFFEF4444), const Color(0xFFFEF2F2), '12', 'Saved Items'),
            ],
          ),

          const SizedBox(height: 14),

          // ── 3. MY WALLET CARD (MATCHING REFERENCE EXACTLY) ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('My Wallet', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      const Text('₹2,450', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                      const SizedBox(height: 2),
                      const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment gateway opened. Add money to wallet.'), backgroundColor: Color(0xFF059669)),
                    );
                  },
                  icon: const Icon(Icons.add_rounded, size: 14, color: Color(0xFF4F46E5)),
                  label: const Text('Add Money', style: TextStyle(color: Color(0xFF4F46E5), fontSize: 11, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    const Icon(Icons.discount_outlined, color: Colors.white, size: 18),
                    const SizedBox(height: 2),
                    const Text('Offers', style: TextStyle(color: Colors.white, fontSize: 9)),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 18),
                        Positioned(
                          top: -3,
                          right: -3,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                            child: const Center(child: Text('1', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text('Rewards', style: TextStyle(color: Colors.white, fontSize: 9)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── 4. MY SERVICES GRID ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              InkWell(
                onTap: () {},
                child: const Text('View All >', style: TextStyle(color: Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildServiceTile(Icons.inventory_2_outlined, const Color(0xFFEA580C), const Color(0xFFFFF7ED), 'My Orders', 'Track & Manage', onTap: () {}),
              const SizedBox(width: 8),
              _buildServiceTile(Icons.build_outlined, const Color(0xFF2563EB), const Color(0xFFEFF6FF), 'My Repairs', 'View Bookings', onTap: () => onNavigateToRepairs?.call()),
              const SizedBox(width: 8),
              _buildServiceTile(Icons.currency_rupee_rounded, const Color(0xFF059669), const Color(0xFFECFDF5), 'My Sell', 'Track Status', onTap: onNavigateToSell),
              const SizedBox(width: 8),
              _buildServiceTile(Icons.receipt_long_outlined, const Color(0xFFDC2626), const Color(0xFFFEF2F2), 'My Quotes', 'Saved Quotes', onTap: () {}),
            ],
          ),

          const SizedBox(height: 20),

          // ── 5. SETTINGS & MENU LIST (MATCHING REFERENCE UI) ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildMenuRow(Icons.favorite_border_rounded, const Color(0xFFEF4444), 'Saved Items', () {}),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildMenuRow(Icons.location_on_outlined, const Color(0xFF8B5CF6), 'My Addresses', () => _showAddressModal(context)),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildMenuRow(Icons.currency_rupee_rounded, const Color(0xFF059669), 'Payment Methods', () => _showPayoutModal(context)),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildMenuRow(Icons.notifications_none_rounded, const Color(0xFFEA580C), 'Notifications', () {}),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildMenuRow(Icons.headset_mic_outlined, const Color(0xFF6366F1), 'Help & Support', () => _showCustomerSupportModal(context)),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildMenuRow(Icons.security_outlined, const Color(0xFF059669), 'Privacy & Security', () => _showTermsModal(context)),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildMenuRow(Icons.settings_outlined, const Color(0xFF64748B), 'App Settings', () => _showWarrantyModal(context)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── 6. REFER & EARN BANNER (MATCHING REFERENCE UI) ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF2F8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFCE7F3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBCFE8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.card_giftcard_rounded, color: Color(0xFFDB2777), size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Refer & Earn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF831843))),
                      SizedBox(height: 2),
                      Text('Invite friends and earn rewards', style: TextStyle(fontSize: 11, color: Color(0xFF9D174D))),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Referral link copied to clipboard! Share with friends to earn ₹500.'), backgroundColor: Color(0xFFDB2777)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Row(
                    children: [
                      Text('Invite Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 14, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── 7. ACTIVE ORDERS LIST ──
          if (orders.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Orders & Tracking', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                Text('${orders.length} active', style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 10),
            ...orders.map((o) => _buildOrderCard(context, o)),
            const SizedBox(height: 16),
          ],

          // ── 8. LOG OUT BUTTON ──
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout_rounded, size: 16, color: Color(0xFFEF4444)),
              label: const Text('Log Out of Maa Ambika', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFECACA)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMetricTile(IconData icon, Color color, Color bg, String count, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 6),
            Text(count, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF0F172A))),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)), textAlign: TextAlign.center, maxLines: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTile(IconData icon, Color color, Color bg, String title, String sub, {required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0F172A)), textAlign: TextAlign.center),
              const SizedBox(height: 2),
              Text(sub, style: const TextStyle(fontSize: 8.5, color: Color(0xFF64748B)), textAlign: TextAlign.center, maxLines: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuRow(IconData icon, Color color, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      dense: true,
      leading: Icon(icon, color: color, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
    );
  }

  Widget _buildOrderCard(BuildContext context, UserOrder o) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: o.type == 'buy' ? const Color(0xFFEDE9FE) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  o.orderNumber,
                  style: TextStyle(
                    color: o.type == 'buy' ? const Color(0xFF7C3AED) : const Color(0xFF059669),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                o.status,
                style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(o.device, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (o.type == 'sell' && o.status.toLowerCase() != 'completed' && o.status.toLowerCase() != 'delivered' && o.status.toLowerCase() != 'paid')
                    ? '${AppConstants.rupeeSymbol} ****'
                    : formatCurrency(o.amount),
                style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A), fontSize: 14),
              ),
              Text('OTP: ${o.otp}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 12),
          Row(
            children: [
              const Icon(Icons.schedule, size: 12, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(o.date, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 20)),
                onPressed: () {
                  _showOrderTimelineModal(context, o);
                },
                child: const Text('View Timeline', style: TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOrderTimelineModal(BuildContext context, UserOrder o) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Status Timeline: ${o.orderNumber}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...List.generate(o.timelineSteps.length, (idx) {
                final isDone = idx <= o.currentStep;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        isDone ? Icons.check_circle : Icons.radio_button_off,
                        color: isDone ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        o.timelineSteps[idx],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                          color: isDone ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // MODAL 1: SAVED DOORSTEP ADDRESSES
  void _showAddressModal(BuildContext context) {
    final addressController = TextEditingController(text: profile.address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on_outlined, color: Color(0xFF059669), size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Saved Doorstep Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          Text('For device pickup & order delivery', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Complete Address',
                    hintText: 'Flat / House No., Building Name, Street / Locality, Landmark, City - PIN Code',
                    hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF059669), width: 2)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Color(0xFF3B82F6)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Our verified pickup partner will arrive at this address for doorstep evaluation.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final newAddress = addressController.text.trim();
                      if (newAddress.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid address')),
                        );
                        return;
                      }
                      onProfileUpdate(profile.copyWith(address: newAddress));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Doorstep address updated successfully!'),
                          backgroundColor: Color(0xFF059669),
                        ),
                      );
                    },
                    child: const Text('Save Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // MODAL 2: PAYOUT UPI & BANK ACCOUNT
  void _showPayoutModal(BuildContext context) {
    final upiController = TextEditingController(text: profile.upiId);
    final bankController = TextEditingController(text: profile.bankAccount);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF059669), size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payout UPI & Bank Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          Text('Instant settlement after device handover', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: upiController,
                  decoration: InputDecoration(
                    labelText: 'UPI ID (Preferred)',
                    hintText: 'e.g. 9876543210@upi or name@okhdfcbank',
                    prefixIcon: const Icon(Icons.flash_on, color: Color(0xFF059669), size: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF059669), width: 2)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bankController,
                  decoration: InputDecoration(
                    labelText: 'Bank Account / IFSC (Optional)',
                    hintText: 'Account No. & IFSC Code',
                    prefixIcon: const Icon(Icons.account_balance_outlined, color: Color(0xFF64748B), size: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF059669), width: 2)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, size: 16, color: Color(0xFF059669)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Zero deduction guarantee: Full amount is credited directly to your bank account or UPI during pickup.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF065F46)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final newUpi = upiController.text.trim();
                      final newBank = bankController.text.trim();
                      if (newUpi.isEmpty && newBank.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a UPI ID or Bank account')),
                        );
                        return;
                      }
                      onProfileUpdate(profile.copyWith(upiId: newUpi, bankAccount: newBank));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payout information saved successfully!'),
                          backgroundColor: Color(0xFF059669),
                        ),
                      );
                    },
                    child: const Text('Save Payout Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // MODAL 3: CUSTOMER SUPPORT
  void _showCustomerSupportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    child: const Icon(Icons.support_agent_outlined, color: Color(0xFF2563EB), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Maa Ambika Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        Text('We are here to help you 7 days a week', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // WhatsApp Tile
              InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  _launchExternalUrl(
                    context,
                    'https://wa.me/918976000010?text=Hello%20Maa%20Ambika%20Support,%20I%20need%20help%20with%20my%20order.',
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Chat on WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF14532D))),
                            Text('+91 8976000010 • Instant response in < 5 mins', style: TextStyle(fontSize: 11, color: Color(0xFF15803D))),
                          ],
                        ),
                      ),
                      const Icon(Icons.open_in_new, size: 16, color: Color(0xFF15803D)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Call Helpline Tile
              InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  _launchExternalUrl(context, 'tel:+918976000010');
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.phone_outlined, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Call Customer Care', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                            Text('+91 8976000010 • Toll-Free / Direct Line', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      const Icon(Icons.call_made, size: 16, color: Color(0xFF64748B)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Email Tile
              InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  _launchExternalUrl(context, 'mailto:support@maaambika.in?subject=Maa%20Ambika%20Customer%20Support');
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.email_outlined, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email Support', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                            Text('support@maaambika.in • Replies within 2 hours', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      const Icon(Icons.mail_outline, size: 16, color: Color(0xFF64748B)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text('Support Timings: 9:00 AM – 9:00 PM IST (Mon - Sun)', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ),
            ],
          ),
        );
      },
    );
  }

  // MODAL 4: WARRANTY & DATA PROTECTION POLICY
  void _showWarrantyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: controller,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.verified_outlined, color: Color(0xFF059669), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Warranty & Data Protection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            Text('DoD 5220.22-M Wipe Certificate & 6-Mo Warranty', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildPolicyCard(
                    icon: Icons.shield_outlined,
                    iconColor: const Color(0xFF059669),
                    title: '1. DoD 5220.22-M Military-Grade Data Wipe',
                    description:
                        'Every device sold to Maa Ambika undergoes a multi-pass military-grade data erasure standard (DoD 5220.22-M). All photos, chats, banking credentials, and private accounts are permanently destroyed, ensuring zero data recovery possibility.',
                  ),
                  const SizedBox(height: 12),

                  _buildPolicyCard(
                    icon: Icons.verified_user_outlined,
                    iconColor: const Color(0xFF2563EB),
                    title: '2. Digital Wipe Certificate',
                    description:
                        'Upon completed doorstep pickup and diagnostic sanitization, a verified digital Certificate of Data Destruction is issued to the seller, relieving you of any future liability on the device.',
                  ),
                  const SizedBox(height: 12),

                  _buildPolicyCard(
                    icon: Icons.replay_circle_filled_outlined,
                    iconColor: const Color(0xFF7C3AED),
                    title: '3. 6-Month Refurbished Warranty',
                    description:
                        'All refurbished devices purchased through Maa Ambika come with a 6-month comprehensive warranty covering screen touch, motherboard, cameras, and battery health with 7-day hassle-free replacement.',
                  ),
                  const SizedBox(height: 12),

                  _buildPolicyCard(
                    icon: Icons.fact_check_outlined,
                    iconColor: const Color(0xFFD97706),
                    title: '4. 32-Point Quality Diagnostic Check',
                    description:
                        'Devices pass rigorous hardware testing by certified diagnostic technicians to ensure 100% genuine functionality before reaching any new customer.',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // MODAL 5: PRIVACY POLICY & TERMS
  void _showTermsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: controller,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF475569), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Privacy Policy & Terms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            Text('Maa Ambika ReCommerce User Agreement', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildPolicyCard(
                    icon: Icons.handshake_outlined,
                    iconColor: const Color(0xFF059669),
                    title: '1. Doorstep ReCommerce Agreement',
                    description:
                        'The online quote generated is valid for 7 days. Our verified field technician performs a 3-minute physical inspection to confirm the conditions declared. Instant payment is transferred prior to handover.',
                  ),
                  const SizedBox(height: 12),

                  _buildPolicyCard(
                    icon: Icons.fingerprint,
                    iconColor: const Color(0xFF2563EB),
                    title: '2. Ownership & Anti-Theft Policy',
                    description:
                        'The seller must be the lawful owner of the device. IMEI numbers are checked against the national CEIR (Central Equipment Identity Register) database to prevent blacklisted or stolen merchandise.',
                  ),
                  const SizedBox(height: 12),

                  _buildPolicyCard(
                    icon: Icons.lock_outline,
                    iconColor: const Color(0xFF7C3AED),
                    title: '3. Data Privacy & Encryption',
                    description:
                        'We value customer privacy. Your mobile number, bank account, and KYC records are stored encrypted (256-bit AES) and never sold to third-party telemarketers.',
                  ),
                  const SizedBox(height: 12),

                  _buildPolicyCard(
                    icon: Icons.gavel_outlined,
                    iconColor: const Color(0xFF475569),
                    title: '4. Grievance Redressal',
                    description:
                        'For any dispute, grievance, or order clarification, you can contact our grievance officer directly at grievance@maaambika.in.',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // MODAL 6: EDIT BASIC PROFILE (Name, Phone, Email)
  void _showEditProfileModal(BuildContext context) {
    final nameController = TextEditingController(text: profile.name);
    final phoneController = TextEditingController(text: profile.phone);
    final emailController = TextEditingController(text: profile.email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.person_outline, color: Color(0xFF059669), size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Edit Personal Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          Text('Keep your contact information updated', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF059669), width: 2)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF059669), width: 2)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF059669), width: 2)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      onProfileUpdate(
                        profile.copyWith(
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          email: emailController.text.trim(),
                        ),
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully!'),
                          backgroundColor: Color(0xFF059669),
                        ),
                      );
                    },
                    child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPolicyCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Color(0xFF475569), fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
