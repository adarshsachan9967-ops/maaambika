import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int _selectedTab = 0; // 0: Overview, 1: Inspection, 2: Images, 3: Notes, 4: History

  void _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label ($text) copied to clipboard!'),
        backgroundColor: const Color(0xFF059669),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final id = o['id'] ?? 'CSM-2024-420';
    final device = o['device'] ?? 'Apple iPhone 16 Pro Max';
    final variant = o['variant'] ?? '256GB • Desert Titanium';
    final customer = o['customer'] ?? 'Adarsh deep Sachan';
    final phone = o['phone'] ?? '9967853364';
    final address = o['address'] ?? 'Gaur City, Delhi NCR - 201009';
    final price = o['price'] ?? '₹61,300';
    final image = o['image'] ?? 'assets/images/refurbished/iphone-15-pro.png';
    final imei = o['imei'] ?? '352948102938472';
    final serial = o['serial'] ?? 'C39DLSK9F4';
    final condition = o['condition'] ?? 'Good';
    final accessories = o['accessories'] ?? 'Original Box, Charger';
    final purchaseDate = o['purchaseDate'] ?? 'Mar 2024';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF0F172A)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── TOP ORDER BANNER CARD ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '#$id',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E8FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Sell', style: TextStyle(color: Color(0xFF7E22CE), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Under Inspection', style: TextStyle(color: Color(0xFFB45309), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const Text('Today, 9:00 AM', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                        child: Image.asset(
                          image,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(Icons.smartphone, size: 32, color: Color(0xFF64748B)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(device, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                            const SizedBox(height: 2),
                            Text(variant, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 12, color: Color(0xFF64748B)),
                                const SizedBox(width: 3),
                                Text(customer, style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
                                const SizedBox(width: 8),
                                const Icon(Icons.phone_outlined, size: 12, color: Color(0xFF64748B)),
                                const SizedBox(width: 3),
                                Text(phone, style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Estimated Payout', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                          const SizedBox(height: 2),
                          Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF059669))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── STEPPER TIMELINE (MATCHING REFERENCE EXACTLY) ──
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStepCircle(icon: Icons.check, isDone: true, isActive: false),
                      _buildStepLine(isDone: true),
                      _buildStepCircle(icon: Icons.check, isDone: true, isActive: false),
                      _buildStepLine(isDone: true),
                      _buildStepCircle(icon: Icons.search_rounded, isDone: false, isActive: true),
                      _buildStepLine(isDone: false),
                      _buildStepCircle(icon: Icons.account_balance_wallet_outlined, isDone: false, isActive: false),
                      _buildStepLine(isDone: false),
                      _buildStepCircle(icon: Icons.check, isDone: false, isActive: false),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        child: Column(
                          children: [
                            Text('Order Created', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)), textAlign: TextAlign.center),
                            Text('9:00 AM\n12 Oct', style: TextStyle(fontSize: 9, color: Color(0xFF64748B)), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Column(
                          children: [
                            Text('Assigned', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)), textAlign: TextAlign.center),
                            Text('10:15 AM\n12 Oct', style: TextStyle(fontSize: 9, color: Color(0xFF64748B)), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 72,
                        child: Column(
                          children: [
                            Text('Under Inspection', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD97706)), textAlign: TextAlign.center),
                            Text('Technician is checking device', style: TextStyle(fontSize: 9, color: Color(0xFFD97706)), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Column(
                          children: [
                            Text('Payout Processing', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 55,
                        child: Column(
                          children: [
                            Text('Completed', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── ASSIGNED TECHNICIAN CARD ──
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1E293B),
                    ),
                    child: const ClipOval(
                      child: Icon(Icons.person, color: Colors.white, size: 26),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amit Kumar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                        Text('Inspection Technician', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.circle, color: Color(0xFF10B981), size: 7),
                            SizedBox(width: 4),
                            Text('On Site', style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _callPhone('9876001122'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.phone_rounded, color: Color(0xFF059669), size: 16),
                          SizedBox(width: 4),
                          Text('Call', style: TextStyle(color: Color(0xFF059669), fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.chat_bubble_rounded, color: Color(0xFF2563EB), size: 16),
                          SizedBox(width: 4),
                          Text('Chat', style: TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── TABS: Overview | Inspection | Images | Notes | History ──
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabButton('Overview', 0),
                  _buildTabButton('Inspection', 1),
                  _buildTabButton('Images (5)', 2),
                  _buildTabButton('Notes (2)', 3),
                  _buildTabButton('History', 4),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── DEVICE DETAILS CARD ──
            Container(
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
                      const Row(
                        children: [
                          Icon(Icons.smartphone_rounded, color: Color(0xFF059669), size: 20),
                          SizedBox(width: 8),
                          Text('Device Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                        ],
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 14, color: Color(0xFF2563EB)),
                            SizedBox(width: 4),
                            Text('Edit', style: TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Image.asset(image, fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(device, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(variant, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            const SizedBox(height: 8),
                            _buildCopyableRow('IMEI', imei),
                            const SizedBox(height: 4),
                            _buildCopyableRow('Serial Number', serial),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildDetailRow('Condition (Declared)', condition, isBadge: true),
                  const SizedBox(height: 8),
                  _buildDetailRow('Accessories', accessories),
                  const SizedBox(height: 8),
                  _buildDetailRow('Purchase Date', purchaseDate),
                  const SizedBox(height: 8),
                  _buildDetailRow('Issue Type', 'No Issue (Sell)'),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── CUSTOMER DETAILS CARD ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.person_outline_rounded, color: Color(0xFFEA580C), size: 20),
                      SizedBox(width: 8),
                      Text('Customer Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(customer, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 3),
                            Text(phone, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            const SizedBox(height: 2),
                            Text(address, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _callPhone(phone),
                        icon: const Icon(Icons.phone_rounded, size: 14, color: Color(0xFF059669)),
                        label: const Text('Call Customer', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 11)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFECFDF5),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── INSPECTION PHOTOS GRID (5 PHOTOS) ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.photo_library_outlined, color: Color(0xFF059669), size: 20),
                          SizedBox(width: 8),
                          Text('Inspection Photos (5)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                        ],
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Text('View All >', style: TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPhotoThumb('assets/images/refurbished/iphone-15-pro-black-front.jpg'),
                        _buildPhotoThumb('assets/images/refurbished/iphone-15-pro-natural-back.jpg'),
                        _buildPhotoThumb('assets/images/refurbished/iphone-15-pro-blue-angle.jpg'),
                        _buildPhotoThumb('assets/images/refurbished/iphone-15-pro-white-angle.jpg'),
                        _buildPhotoThumb('assets/images/refurbished/iphone-15-pro-natural-camera.jpg'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── BOTTOM ACTION BAR (CANCEL, RESCHEDULE, PROCEED TO PAYOUT) ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order cancelled.'), backgroundColor: Color(0xFFEF4444)),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFECACA)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pickup rescheduled.'), backgroundColor: Color(0xFF2563EB)),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      side: const BorderSide(color: Color(0xFFBFDBFE)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Reschedule', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payout of $price initiated to customer!'), backgroundColor: const Color(0xFF059669)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Proceed to Payout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCircle({required IconData icon, required bool isDone, required bool isActive}) {
    Color bg;
    Color iconColor;
    if (isDone) {
      bg = const Color(0xFF059669);
      iconColor = Colors.white;
    } else if (isActive) {
      bg = const Color(0xFFEA580C);
      iconColor = Colors.white;
    } else {
      bg = const Color(0xFFE2E8F0);
      iconColor = const Color(0xFF94A3B8);
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 16),
    );
  }

  Widget _buildStepLine({required bool isDone}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isDone ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
      ),
    );
  }

  Widget _buildTabButton(String title, int idx) {
    final isSelected = _selectedTab == idx;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedTab = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF059669) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0)),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCopyableRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const SizedBox(width: 4),
        InkWell(
          onTap: () => _copyToClipboard(value, label),
          child: const Icon(Icons.copy_rounded, size: 13, color: Color(0xFF2563EB)),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBadge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(6)),
            child: Text(value, style: const TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.bold)),
          )
        else
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
      ],
    );
  }

  Widget _buildPhotoThumb(String assetPath) {
    return Container(
      width: 68,
      height: 68,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const Icon(Icons.image_outlined, color: Color(0xFF94A3B8)),
        ),
      ),
    );
  }
}
