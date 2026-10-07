import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/user_order.dart';
import '../../models/user_profile.dart';

class BuyRefurbishedWidget extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final Function(UserOrder) onOrderCreated;

  const BuyRefurbishedWidget({
    super.key,
    required this.products,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onOrderCreated,
  });

  @override
  State<BuyRefurbishedWidget> createState() => _BuyRefurbishedWidgetState();
}

class _BuyRefurbishedWidgetState extends State<BuyRefurbishedWidget> {
  String _selectedCategory = 'all';
  String _selectedCondition = 'all';
  String _searchQuery = '';
  Map<String, dynamic>? _activeDetailProduct;
  int _selectedUnitIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (_activeDetailProduct != null) {
      return _buildProductDetailView();
    }

    var filtered = widget.products;
    if (_selectedCategory != 'all') {
      filtered = filtered.where((p) => (p['category'] as String).toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }
    if (_selectedCondition != 'all') {
      filtered = filtered.where((p) => (p['condition'] as String).toLowerCase() == _selectedCondition.toLowerCase()).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      filtered = filtered.where((p) =>
        (p['model'] as String).toLowerCase().contains(q) ||
        (p['brand'] as String).toLowerCase().contains(q)
      ).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
        title: const Text('Buy Certified Refurbished', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search iPhone, MacBook, Canon, Sony...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('all', 'All Categories'),
                      _buildCategoryChip('smartphones', 'Smartphones'),
                      _buildCategoryChip('cameras', 'Cameras'),
                      _buildCategoryChip('laptops', 'Laptops'),
                      _buildCategoryChip('tablets', 'Tablets'),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildConditionChip('all', 'All Conditions'),
                      _buildConditionChip('superb', 'Superb (Like New)'),
                      _buildConditionChip('good', 'Good Condition'),
                      _buildConditionChip('fair', 'Fair Condition'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No devices found matching your criteria.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, idx) {
                      final p = filtered[idx];
                      final name = p['model'] as String;
                      final price = p['sellingPrice'] as int;
                      final origPrice = p['originalPrice'] as int;
                      final battery = p['batteryHealth'] as String;
                      final condition = p['condition'] as String;
                      final image = p['image'] as String;
                      final units = (p['availableUnits'] as List?) ?? [];

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _activeDetailProduct = p;
                            _selectedUnitIndex = 0;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(10),
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDE9FE),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      condition,
                                      style: const TextStyle(color: Color(0xFF6D28D9), fontSize: 9, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    '${units.length} Units',
                                    style: const TextStyle(color: Color(0xFF059669), fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    image,
                                    fit: BoxFit.contain,
                                    errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 36, color: Color(0xFF94A3B8)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                              ),
                              Text(
                                battery,
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    formatCurrency(price),
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF059669)),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    formatCurrency(origPrice),
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Color(0xFF94A3B8),
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String val, String label) {
    final isSel = _selectedCategory == val;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSel,
        onSelected: (s) => setState(() => _selectedCategory = val),
        selectedColor: const Color(0xFF059669),
        labelStyle: TextStyle(
          color: isSel ? Colors.white : const Color(0xFF0F172A),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildConditionChip(String val, String label) {

    final isSel = _selectedCondition == val;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSel,
        onSelected: (s) => setState(() => _selectedCondition = val),
        selectedColor: const Color(0xFF4F46E5),
        labelStyle: TextStyle(
          color: isSel ? Colors.white : const Color(0xFF0F172A),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // PRODUCT DETAIL VIEW WITH SAME-PAGE MULTIPLE UNITS SELECTOR
  Widget _buildProductDetailView() {
    final p = _activeDetailProduct!;
    final units = (p['availableUnits'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final activeUnit = units.isNotEmpty && _selectedUnitIndex < units.length
        ? units[_selectedUnitIndex]
        : <String, dynamic>{};

    final currentPrice = (activeUnit['price'] as num?)?.toInt() ?? (p['sellingPrice'] as int);
    final currentBattery = activeUnit['batteryHealth'] as String? ?? (p['batteryHealth'] as String);
    final gallery = (p['gallery'] as List?)?.cast<String>() ?? [p['image'] as String];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
        title: Text(p['model'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _activeDetailProduct = null),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gallery
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: gallery.length,
                itemBuilder: (c, i) => Center(
                  child: Image.asset(
                    gallery[i],
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, e, s) => const Icon(Icons.devices, size: 60, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              p['model'] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 4),
            Text(
              p['specs'] as String? ?? '',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  formatCurrency(currentPrice),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
                ),
                const SizedBox(width: 8),
                Text(
                  formatCurrency(p['originalPrice'] as int),
                  style: const TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF94A3B8), fontSize: 14),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    '${p['discount']}% OFF',
                    style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // MULTIPLE UNITS SELECTOR ON SAME PAGE (Section 20 & 21)
            const Text('Select Tracked Available Unit:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            ...List.generate(units.length, (uIdx) {
              final u = units[uIdx];
              final isSel = _selectedUnitIndex == uIdx;
              final uNote = u['note'] as String? ?? 'Unit ${uIdx + 1}';
              final uPrice = (u['price'] as num?)?.toInt() ?? currentPrice;

              return InkWell(
                onTap: () => setState(() => _selectedUnitIndex = uIdx),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFF059669).withValues(alpha: 0.06) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSel ? const Color(0xFF059669) : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSel ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(uNote, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('Battery / Health: $currentBattery', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      Text(
                        formatCurrency(uPrice),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            // Inspection Scorecard
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified, color: Color(0xFF059669), size: 16),
                      SizedBox(width: 6),
                      Text('45-Point Hardware Diagnostics Passed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('✓ OLED / Retinal Panel: 100% Passed\n✓ TrueTone & 120Hz ProMotion: Verified\n✓ Battery Longevity: Verified Operational\n✓ Cameras & OIS Stabilization: 100% Tested\n✓ 12-Month Maa Ambika Comprehensive Warranty Included',
                    style: TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                onPressed: () => _handleBuyCheckout(currentPrice),
                child: const Text('Proceed to Instant Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBuyCheckout(int finalPrice) async {
    final orderData = {
      'type': 'buy',
      'customerName': widget.userProfile.name,
      'customerPhone': widget.userProfile.phone,
      'customerAddress': widget.userProfile.address,
      'amount': finalPrice,
      'deviceName': 'Refurbished ${_activeDetailProduct!['model']}',
      'status': 'Order Placed',
      'paymentMethod': 'Prepaid / Online UPI',
    };

    final created = await ApiService.createOrder(orderData);
    if (created != null && mounted) {
      setState(() => _activeDetailProduct = null);
      widget.onOrderCreated(UserOrder.fromJson(created));
    }
  }
}
