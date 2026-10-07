import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/user_order.dart';
import '../../models/user_profile.dart';

class ExchangeWorkflowWidget extends StatefulWidget {
  final List<Map<String, dynamic>> refurbishedProducts;
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final Function(UserOrder) onOrderCreated;

  const ExchangeWorkflowWidget({
    super.key,
    required this.refurbishedProducts,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onOrderCreated,
  });

  @override
  State<ExchangeWorkflowWidget> createState() => _ExchangeWorkflowWidgetState();
}

class _ExchangeWorkflowWidgetState extends State<ExchangeWorkflowWidget> {
  // Steps: 0: select-old, 1: condition, 2: select-new, 3: product-detail, 4: checkout, 5: confirmed
  int _step = 0;

  // Step 0: Trade-in Old Device
  String _oldCategoryFilter = 'all';
  String _oldSearchQuery = '';
  List<Map<String, dynamic>> _tradeInDevices = [];
  Map<String, dynamic>? _selectedOldDevice;

  // Step 1: Diagnostics & Valuation
  List<Map<String, dynamic>> _questions = [];
  final Map<int, int> _selectedAnswers = {};
  int _oldBaseValue = 48000;
  int _calculatedOldValue = 45000;
  final int _exchangeBonus = 5000; // Guaranteed Maa Ambika exchange bonus

  // Step 2: Browse Upgrade Catalog
  String _newCategoryFilter = 'all';
  String _newSearchQuery = '';

  // Step 3: Product Detail View
  Map<String, dynamic>? _selectedNewDevice;
  String _selectedCondition = 'Superb';
  int _selectedUnitIndex = 0;

  // Step 4: Checkout, Coupons & Address
  String? _appliedCouponCode;
  int _couponDiscount = 0;
  final TextEditingController _couponController = TextEditingController();
  String _selectedDate = 'Tomorrow';
  String _selectedSlot = '10:00 AM – 1:00 PM';
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _pincodeController;
  bool _isPlacingOrder = false;

  // Step 5: Confirmed Order
  UserOrder? _confirmedOrder;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _phoneController = TextEditingController(text: widget.userProfile.phone);
    _addressController = TextEditingController(text: widget.userProfile.address);
    _cityController = TextEditingController(text: 'Mumbai');
    _pincodeController = TextEditingController(text: '401107');
    _loadTradeInDevices();
  }

  @override
  void dispose() {
    _couponController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _loadTradeInDevices() {
    final allModels = ApiService.getFallbackModelsSync();
    setState(() {
      _tradeInDevices = allModels;
    });
  }

  void _recalcOldValue() {
    int val = _oldBaseValue;
    for (int qIdx = 0; qIdx < _questions.length; qIdx++) {
      final optIdx = _selectedAnswers[qIdx] ?? 0;
      final options = _questions[qIdx]['options'] as List?;
      if (options != null && optIdx < options.length) {
        final adj = (options[optIdx]['adj'] as num?)?.toInt() ?? 0;
        val += adj;
      }
    }
    setState(() {
      _calculatedOldValue = val > 4000 ? val : 4000;
    });
  }

  int _getAdjustedNewDevicePrice() {
    final basePrice = (_selectedNewDevice?['sellingPrice'] as int?) ?? 70000;
    if (_selectedCondition == 'Good') return (basePrice * 0.92).toInt();
    if (_selectedCondition == 'Fair') return (basePrice * 0.85).toInt();
    return basePrice;
  }

  void _applyCoupon(String code) {
    final c = code.trim().toUpperCase();
    if (c == 'MAAAMBIKA500' || c == 'CAMSIK500') {
      setState(() {
        _appliedCouponCode = c;
        _couponDiscount = 500;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon MAAAMBIKA500 applied! \u20B9500 extra discount.'), backgroundColor: Color(0xFF059669)),
      );
    } else if (c == 'UPGRADE1000') {
      setState(() {
        _appliedCouponCode = c;
        _couponDiscount = 1000;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon UPGRADE1000 applied! \u20B91,000 extra discount.'), backgroundColor: Color(0xFF059669)),
      );
    } else if (c == 'FESTIVE1500') {
      setState(() {
        _appliedCouponCode = c;
        _couponDiscount = 1500;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon FESTIVE1500 applied! \u20B91,500 extra discount.'), backgroundColor: Color(0xFF059669)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid coupon code. Try MAAAMBIKA500 or UPGRADE1000.'), backgroundColor: Color(0xFFDC2626)),
      );
    }
  }

  void _handleConfirmExchange() async {
    final newPrice = _getAdjustedNewDevicePrice();
    final totalTradeIn = _calculatedOldValue + _exchangeBonus;
    final netDiff = newPrice - totalTradeIn - _couponDiscount;
    final netPayable = netDiff > 0 ? netDiff : 0;

    setState(() => _isPlacingOrder = true);

    final orderData = {
      'type': 'exchange',
      'customerName': _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : widget.userProfile.name,
      'customerPhone': _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : widget.userProfile.phone,
      'customerAddress': '${_addressController.text.trim()}, ${_cityController.text.trim()} - ${_pincodeController.text.trim()}',
      'pickupDate': _selectedDate,
      'pickupSlot': _selectedSlot,
      'amount': netPayable,
      'deviceName': '${_selectedOldDevice?['name']} ➔ ${_selectedNewDevice?['model']}',
      'status': 'Exchange Confirmed',
      'paymentMethod': netDiff <= 0 ? 'Cashback Disbursal via UPI' : 'Doorstep Swap (Cash / UPI)',
    };

    final created = await ApiService.createOrder(orderData);
    if (!mounted) return;
    setState(() => _isPlacingOrder = false);

    final order = UserOrder.fromJson(created ?? orderData);
    widget.onOrderCreated(order);

    setState(() {
      _confirmedOrder = order;
      _step = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
        title: Text(_getStepTitle(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        leading: _step > 0 && _step < 5
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _step--),
              )
            : null,
      ),
      body: _buildStepContent(),
    );
  }

  String _getStepTitle() {
    switch (_step) {
      case 0:
        return 'Step 1 of 5: Select Old Device';
      case 1:
        return 'Step 2 of 5: Old Device Condition';
      case 2:
        return 'Step 3 of 5: Select Upgrade Device';
      case 3:
        return 'Step 4 of 5: Upgrade Details';
      case 4:
        return 'Step 5 of 5: Exchange Checkout';
      case 5:
        return '1-Step Exchange Confirmed';
      default:
        return 'Device Exchange';
    }
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildSelectOldStep();
      case 1:
        return _buildOldQuestionsStep();
      case 2:
        return _buildSelectNewStep();
      case 3:
        return _buildProductDetailStep();
      case 4:
        return _buildCheckoutStep();
      case 5:
        return _buildConfirmedStep();
      default:
        return _buildSelectOldStep();
    }
  }

  // ── STEP 0: SELECT OLD DEVICE ──
  Widget _buildSelectOldStep() {
    final catList = [
      {'id': 'all', 'label': 'All Devices'},
      {'id': 'cat-dslr', 'label': 'Cameras'},
      {'id': 'cat-lens', 'label': 'Lenses'},
      {'id': 'cat-smartphone', 'label': 'Smartphones'},
      {'id': 'cat-laptop', 'label': 'Laptops'},
    ];

    var filtered = _tradeInDevices;
    if (_oldCategoryFilter != 'all') {
      filtered = filtered.where((d) => (d['categoryId'] as String? ?? '').toLowerCase() == _oldCategoryFilter.toLowerCase()).toList();
    }
    if (_oldSearchQuery.trim().isNotEmpty) {
      final q = _oldSearchQuery.toLowerCase().trim();
      filtered = filtered.where((d) =>
        (d['name'] as String? ?? '').toLowerCase().contains(q) ||
        (d['brand'] as String? ?? '').toLowerCase().contains(q)
      ).toList();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                onChanged: (v) => setState(() => _oldSearchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search old iPhone, Sony A7, Canon, MacBook...',
                  prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
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
                  children: catList.map((cat) {
                    final isSel = _oldCategoryFilter == cat['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(cat['label']!),
                        selected: isSel,
                        onSelected: (val) {
                          if (val) setState(() => _oldCategoryFilter = cat['id']!);
                        },
                        selectedColor: const Color(0xFF7C3AED),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : const Color(0xFF0F172A),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (c, i) => const SizedBox(height: 10),
            itemBuilder: (ctx, idx) {
              final d = filtered[idx];
              final name = d['name'] as String? ?? 'Device';
              final base = (d['basePrice'] as num?)?.toInt() ?? 45000;
              final image = d['image'] as String? ?? 'assets/images/categories/dslr.png';
              final specs = d['specs'] as String? ?? 'Verified hardware valuation';

              return InkWell(
                onTap: () {
                  final catId = d['categoryId'] as String? ?? 'cat-dslr';
                  final questions = ApiService.getQuestionsSync(categoryId: catId);
                  setState(() {
                    _selectedOldDevice = d;
                    _oldBaseValue = base;
                    _questions = questions;
                    _selectedAnswers.clear();
                    for (int i = 0; i < _questions.length; i++) {
                      _selectedAnswers[i] = 0;
                    }
                    _step = 1;
                  });
                  _recalcOldValue();
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                        child: Image.asset(image, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 28, color: Color(0xFF7C3AED))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                            const SizedBox(height: 2),
                            Text(specs, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Base: ${formatCurrency(base)}', style: const TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(6)),
                                  child: const Text('+$kRupee 5,000 Bonus', style: TextStyle(color: Color(0xFF7C3AED), fontSize: 9, fontWeight: FontWeight.w900)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── STEP 1: OLD DEVICE CONDITION & DIAGNOSTICS ──
  Widget _buildOldQuestionsStep() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B0764), Color(0xFF1E1B4B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_selectedOldDevice?['name'] ?? 'Old Device', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  const Text('Valuation + $kRupee 5,000 Exchange Bonus', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
              Text(
                formatCurrency(_calculatedOldValue + _exchangeBonus),
                style: const TextStyle(color: Color(0xFFC084FC), fontWeight: FontWeight.w900, fontSize: 20),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _questions.length,
            separatorBuilder: (c, i) => const SizedBox(height: 14),
            itemBuilder: (ctx, qIdx) {
              final q = _questions[qIdx];
              final options = (q['options'] as List?)?.cast<Map<String, dynamic>>() ?? [];
              final sel = _selectedAnswers[qIdx] ?? 0;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${qIdx + 1}. ${q['question']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(options.length, (optIdx) {
                      final opt = options[optIdx];
                      final isSel = sel == optIdx;
                      final adj = (opt['adj'] as num?)?.toInt() ?? 0;

                      return InkWell(
                        onTap: () {
                          setState(() => _selectedAnswers[qIdx] = optIdx);
                          _recalcOldValue();
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFF7C3AED).withValues(alpha: 0.08) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSel ? const Color(0xFF7C3AED) : const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 16,
                                color: isSel ? const Color(0xFF7C3AED) : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(opt['label'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                              if (adj != 0)
                                Text(
                                  adj > 0 ? '+${formatCurrency(adj)}' : '-${formatCurrency(adj.abs())}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: adj > 0 ? const Color(0xFF059669) : const Color(0xFFEF4444),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 3,
              ),
              onPressed: () => setState(() => _step = 2),
              child: const Text('Next: Choose Upgrade Device', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ),
      ],
    );
  }

  // ── STEP 2: SELECT UPGRADE REFURBISHED DEVICE ──
  Widget _buildSelectNewStep() {
    final catList = [
      {'id': 'all', 'label': 'All Upgrades'},
      {'id': 'cameras', 'label': 'Cameras'},
      {'id': 'lenses', 'label': 'Lenses'},
      {'id': 'smartphones', 'label': 'Smartphones'},
      {'id': 'laptops', 'label': 'Laptops'},
    ];

    var filtered = widget.refurbishedProducts;
    if (_newCategoryFilter != 'all') {
      filtered = filtered.where((p) => (p['category'] as String? ?? '').toLowerCase() == _newCategoryFilter.toLowerCase()).toList();
    }
    if (_newSearchQuery.trim().isNotEmpty) {
      final q = _newSearchQuery.toLowerCase().trim();
      filtered = filtered.where((p) =>
        (p['model'] as String? ?? '').toLowerCase().contains(q) ||
        (p['brand'] as String? ?? '').toLowerCase().contains(q)
      ).toList();
    }

    final totalTradeIn = _calculatedOldValue + _exchangeBonus;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                onChanged: (v) => setState(() => _newSearchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search upgrade flagships (Sony, Canon, iPhone, Mac)...',
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
                  children: catList.map((cat) {
                    final isSel = _newCategoryFilter == cat['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(cat['label']!),
                        selected: isSel,
                        onSelected: (val) {
                          if (val) setState(() => _newCategoryFilter = cat['id']!);
                        },
                        selectedColor: const Color(0xFF4F46E5),
                        labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (c, i) => const SizedBox(height: 10),
            itemBuilder: (ctx, idx) {
              final p = filtered[idx];
              final name = p['model'] as String? ?? 'Device';
              final price = p['sellingPrice'] as int? ?? 65000;
              final image = p['image'] as String? ?? 'assets/images/categories/dslr.png';
              final diff = price - totalTradeIn;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedNewDevice = p;
                    _selectedCondition = 'Superb';
                    _selectedUnitIndex = 0;
                    _step = 3;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                        child: Image.asset(image, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 28, color: Color(0xFF4F46E5))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text('Price: ${formatCurrency(price)}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(
                              diff > 0 ? 'Pay Difference: ${formatCurrency(diff)}' : 'You Receive: +${formatCurrency(diff.abs())} Cash',
                              style: TextStyle(
                                color: diff > 0 ? const Color(0xFF4F46E5) : const Color(0xFF059669),
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── STEP 3: PRODUCT DETAIL SCREEN (GALLERY, CONDITION TABS, UNITS, 45-POINT CHECK) ──
  Widget _buildProductDetailStep() {
    if (_selectedNewDevice == null) return const Center(child: Text('Device not selected'));

    final p = _selectedNewDevice!;
    final name = p['model'] as String? ?? 'Device';
    final brand = p['brand'] as String? ?? 'Brand';
    final image = p['image'] as String? ?? 'assets/images/categories/dslr.png';
    final specs = p['specs'] as String? ?? 'Certified 45-point hardware tested with comprehensive warranty.';
    final units = (p['availableUnits'] as List?) ?? [
      {'serial': 'CSM-8821', 'batteryHealth': '96%', 'warranty': '12 Months'},
      {'serial': 'CSM-8822', 'batteryHealth': '92%', 'warranty': '12 Months'},
    ];

    final adjustedPrice = _getAdjustedNewDevicePrice();
    final totalTradeIn = _calculatedOldValue + _exchangeBonus;
    final netDiff = adjustedPrice - totalTradeIn;
    final netPayable = netDiff > 0 ? netDiff : 0;
    final cashback = netDiff < 0 ? netDiff.abs() : 0;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Main Image
                Center(
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Image.asset(image, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 64, color: Color(0xFF4F46E5))),
                  ),
                ),
                const SizedBox(height: 16),

                // Title and Brand
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                Text('$brand · Certified Refurbished', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                const SizedBox(height: 14),

                // Condition Selector Tabs (Superb, Good, Fair)
                const Text('Select Refurbished Grade:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildConditionChip('Superb', 'Superb (Like New)'),
                    const SizedBox(width: 8),
                    _buildConditionChip('Good', 'Good Condition'),
                    const SizedBox(width: 8),
                    _buildConditionChip('Fair', 'Fair Condition'),
                  ],
                ),
                const SizedBox(height: 16),

                // Available Unit Selector
                const Text('Select Verified Serial Unit:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(units.length, (uIdx) {
                    final u = units[uIdx] as Map<String, dynamic>;
                    final isSel = _selectedUnitIndex == uIdx;
                    final serial = u['serial']?.toString() ?? 'Unit ${uIdx + 1}';
                    final battery = u['batteryHealth']?.toString() ?? '95%';
                    final warranty = u['warranty']?.toString() ?? '12 Months';

                    return InkWell(
                      onTap: () => setState(() => _selectedUnitIndex = uIdx),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFF4F46E5).withValues(alpha: 0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSel ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(isSel ? Icons.check_circle : Icons.radio_button_off, color: isSel ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8), size: 18),
                                const SizedBox(width: 8),
                                Text(serial, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                                  child: Text('Battery: $battery', style: const TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(6)),
                                  child: Text(warranty, style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // 45-Point Inspection Checklist Badge
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.verified, color: Color(0xFF059669), size: 18),
                          SizedBox(width: 6),
                          Text('45-Point Hardware Certified', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(specs, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Live Exchange Calculation Sticky Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -3)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cashback > 0 ? 'Cashback to You:' : 'Net Difference:',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      Text(
                        cashback > 0 ? '+$kRupee${formatCurrency(cashback)}' : formatCurrency(netPayable),
                        style: TextStyle(
                          color: cashback > 0 ? const Color(0xFF059669) : const Color(0xFF4F46E5),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => setState(() => _step = 4),
                    child: const Row(
                      children: [
                        Text('Proceed to Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConditionChip(String key, String label) {
    final isSel = _selectedCondition == key;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedCondition = key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSel ? const Color(0xFF4F46E5) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSel ? const Color(0xFF4F46E5) : const Color(0xFFCBD5E1)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSel ? Colors.white : const Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // ── STEP 4: CHECKOUT, COUPONS & ADDRESS ──
  Widget _buildCheckoutStep() {
    final adjustedPrice = _getAdjustedNewDevicePrice();
    final totalTradeIn = _calculatedOldValue + _exchangeBonus;
    final netDiff = adjustedPrice - totalTradeIn - _couponDiscount;
    final netPayable = netDiff > 0 ? netDiff : 0;
    final cashback = netDiff < 0 ? netDiff.abs() : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exchange Overview Cards
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildSummaryLine('Upgraded Device ($_selectedCondition)', formatCurrency(adjustedPrice)),
                _buildSummaryLine('Old Device Trade-In Valuation', formatCurrency(_calculatedOldValue)),
                _buildSummaryLine('Guaranteed Maa Ambika Exchange Bonus', '+$kRupee 5,000', isBonus: true),
                if (_couponDiscount > 0)
                  _buildSummaryLine('Coupon ($_appliedCouponCode)', '-${formatCurrency(_couponDiscount)}', isBonus: true),
                const Divider(height: 16),
                _buildSummaryLine(
                  cashback > 0 ? 'Cashback Paid to You on Handover' : 'Net Doorstep Payable Balance',
                  cashback > 0 ? '+$kRupee${formatCurrency(cashback)}' : formatCurrency(netPayable),
                  isBold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Coupon Code Section
          const Text('Apply Upgrade Coupon:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Enter coupon code',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () => _applyCoupon(_couponController.text),
                child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ActionChip(
                  label: const Text('MAAAMBIKA500 (-$kRupee 500)'),
                  onPressed: () {
                    _couponController.text = 'MAAAMBIKA500';
                    _applyCoupon('MAAAMBIKA500');
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('UPGRADE1000 (-$kRupee 1,000)'),
                  onPressed: () {
                    _couponController.text = 'UPGRADE1000';
                    _applyCoupon('UPGRADE1000');
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('FESTIVE1500 (-$kRupee 1,500)'),
                  onPressed: () {
                    _couponController.text = 'FESTIVE1500';
                    _applyCoupon('FESTIVE1500');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Doorstep Handover Slot
          const Text('Select Handover Date & Time Slot:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: ['Tomorrow', 'Day After'].map((d) {
              final isSel = _selectedDate == d;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(d),
                  selected: isSel,
                  onSelected: (v) => setState(() => _selectedDate = d),
                  selectedColor: const Color(0xFF7C3AED),
                  labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 11),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['10:00 AM – 1:00 PM', '2:00 PM – 5:00 PM', '5:00 PM – 8:00 PM'].map((s) {
              final isSel = _selectedSlot == s;
              return ChoiceChip(
                label: Text(s),
                selected: isSel,
                onSelected: (v) => setState(() => _selectedSlot = s),
                selectedColor: const Color(0xFF7C3AED),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 11),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Handover Address Form
          const Text('Doorstep Handover Details:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Mobile Phone',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _addressController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Delivery & Handover Address',
              hintText: 'Flat, Wing, Building, Road name',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'City', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Pincode', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Payment Preference
          const Text('Payment Settlement Preference:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Row(
              children: [
                const Icon(Icons.handshake, color: Color(0xFF059669)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cashback > 0 ? 'Technician pays cash / UPI to you on doorstep' : 'Pay balance to technician at doorstep via Cash / UPI',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              onPressed: _isPlacingOrder ? null : _handleConfirmExchange,
              child: _isPlacingOrder
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : const Text('Confirm 1-Step Doorstep Swap Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  // ── STEP 5: CONFIRMED ORDER RECEIPT ──
  Widget _buildConfirmedStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 52),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '1-Step Exchange Booked!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your doorstep swap has been scheduled successfully.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Verification OTP Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Order Number:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Text(_confirmedOrder?.orderNumber ?? 'CSM-EXC-94821', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Doorstep Handover OTP:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(8)),
                      child: Text(_confirmedOrder?.otp ?? '8921', style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Scheduled Slot:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Text('$_selectedDate ($_selectedSlot)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                setState(() => _step = 0);
              },
              child: const Text('Exchange Another Device', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryLine(String label, String value, {bool isBonus = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: const Color(0xFF475569))),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              color: isBonus ? const Color(0xFF059669) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
