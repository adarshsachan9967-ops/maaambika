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

  const UserProfileWidget({
    super.key,
    required this.profile,
    required this.orders,
    required this.onProfileUpdate,
    required this.onLogout,
    required this.onNavigateToSell,
    required this.onNavigateToBuy,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF059669),
                  child: Text(
                    profile.name.isNotEmpty ? profile.name.substring(0, 1).toUpperCase() : 'C',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name.isNotEmpty ? profile.name : 'Maa Ambika Customer',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.phone.isNotEmpty ? profile.phone : '+91 Not Set',
                        style: const TextStyle(color: Color(0xFF34D399), fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        profile.email.isNotEmpty ? profile.email : 'Add email address',
                        style: const TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white70, size: 20),
                  tooltip: 'Edit Profile',
                  onPressed: () => _showEditProfileModal(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // MY ORDERS SECTION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Orders & Handover Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Text('${orders.length} Active', style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          if (orders.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 40, color: Color(0xFF94A3B8)),
                    SizedBox(height: 8),
                    Text('No orders yet', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('Sell, buy, or exchange devices to see your orders here.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  ],
                ),
              ),
            )
          else
            ...orders.map((o) => _buildOrderCard(context, o)),

          const SizedBox(height: 24),
          const Text('Account & Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),

          _buildSettingsTile(
            context,
            icon: Icons.location_on_outlined,
            title: 'Saved Doorstep Addresses',
            subtitle: profile.address.isNotEmpty ? profile.address : 'Add doorstep pickup & delivery address',
            onTap: () => _showAddressModal(context),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.account_balance_wallet_outlined,
            title: 'Payout UPI & Bank Account',
            subtitle: profile.upiId.isNotEmpty
                ? 'UPI: ${profile.upiId}'
                : (profile.bankAccount.isNotEmpty ? 'Bank: ${profile.bankAccount}' : 'Add UPI or Bank for instant payment'),
            onTap: () => _showPayoutModal(context),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.support_agent_outlined,
            title: 'Customer Support',
            subtitle: 'WhatsApp & Call: +91 8976000010 (9 AM - 9 PM)',
            onTap: () => _showCustomerSupportModal(context),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.verified_outlined,
            title: 'Warranty & Data Protection Policy',
            subtitle: 'DoD 5220.22-M Wipe Certificate & 6-Mo Warranty',
            onTap: () => _showWarrantyModal(context),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy & Terms',
            subtitle: 'Maa Ambika ReCommerce terms & condition',
            onTap: () => _showTermsModal(context),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
                side: const BorderSide(color: Color(0xFFEF4444)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: onLogout,
              child: const Text('Log Out of Maa Ambika', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
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

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF059669), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ),
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
