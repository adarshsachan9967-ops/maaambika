import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/user_order.dart';
import '../../models/user_profile.dart';

class SellWorkflowWidget extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final String? preselectedCategory;
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final Function(UserOrder) onOrderCreated;

  const SellWorkflowWidget({
    super.key,
    required this.categories,
    this.preselectedCategory,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onOrderCreated,
  });

  @override
  State<SellWorkflowWidget> createState() => _SellWorkflowWidgetState();
}

class _SellWorkflowWidgetState extends State<SellWorkflowWidget> {
  int _currentStep = 0; // 0: Device Details, 1: Condition, 2: Pickup, 3: Quote

  // Step 0: Selections
  int _selectedDeviceType = 0; // 0: Smartphone, 1: Laptop, 2: Tablet, 3: Smartwatch, 4: Accessories
  String _selectedBrand = 'Apple';
  String _selectedModelName = 'iPhone 15 Pro';
  String _selectedVariant = '128GB';
  String _selectedColor = 'Blue Titanium';

  final List<Map<String, dynamic>> _deviceTypes = [
    {'title': 'Smartphone', 'sub': 'Sell Old Phones', 'icon': Icons.smartphone_rounded, 'img': 'assets/images/refurbished/iphone-15-pro.png'},
    {'title': 'Laptop', 'sub': 'Sell Old Laptops', 'icon': Icons.laptop_mac_rounded, 'img': 'assets/images/refurbished/macbook-air-m2.png'},
    {'title': 'Tablet', 'sub': 'Sell Old Tablets', 'icon': Icons.tablet_mac_rounded, 'img': 'assets/images/refurbished/galaxy-tab-s9.jpg'},
    {'title': 'Smartwatch', 'sub': 'Sell Smart Watches', 'icon': Icons.watch_rounded, 'img': 'assets/images/refurbished/apple-watch-ultra.jpg'},
    {'title': 'Accessories', 'sub': 'Sell Accessories', 'icon': Icons.headphones_rounded, 'img': 'assets/images/categories/dslr.png'},
  ];

  final List<String> _brands = [
    'Apple', 'Samsung', 'Xiaomi', 'Oppo', 'Vivo', 'OnePlus', 'Google', 'Realme', 'Motorola', 'Other'
  ];

  final List<String> _modelsList = [
    'iPhone 15 Pro', 'iPhone 15 Pro Max', 'iPhone 15', 'iPhone 14 Pro', 'Galaxy S24 Ultra', 'OnePlus 12'
  ];

  final List<String> _variants = ['128GB', '256GB', '512GB', '1TB'];

  final List<Map<String, dynamic>> _colors = [
    {'name': 'Blue Titanium', 'img': 'assets/images/refurbished/iphone-15-pro-blue-front.jpg'},
    {'name': 'White Titanium', 'img': 'assets/images/refurbished/iphone-15-pro-white-front.jpg'},
    {'name': 'Natural Titanium', 'img': 'assets/images/refurbished/iphone-15-pro-natural-back.jpg'},
    {'name': 'Black Titanium', 'img': 'assets/images/refurbished/iphone-15-pro-black-front.jpg'},
  ];

  // Step 1: Condition questions & valuation
  final Map<int, int> _conditionAnswers = {0: 0, 1: 0, 2: 0, 3: 0};
  final List<Map<String, dynamic>> _conditionQuestions = [
    {
      'title': 'Does the display touch & screen work without flaws or lines?',
      'options': [
        {'label': 'Yes, Flawless Screen', 'adj': 0},
        {'label': 'Minor Scratches', 'adj': -3500},
        {'label': 'Cracked Screen / Lines', 'adj': -8500},
      ],
    },
    {
      'title': 'Are there any dents, bends or cracks on the back panel / frame?',
      'options': [
        {'label': 'No Dents (Flawless)', 'adj': 0},
        {'label': '1-2 Minor Dents', 'adj': -2000},
        {'label': 'Heavily Dented / Cracked Back', 'adj': -5000},
      ],
    },
    {
      'title': 'Do all front and rear cameras focus and capture clearly?',
      'options': [
        {'label': 'All Cameras Functional', 'adj': 0},
        {'label': 'Blurry or Flash Issue', 'adj': -2500},
        {'label': 'Broken Lens Glass', 'adj': -4500},
      ],
    },
    {
      'title': 'Do you have original accessories?',
      'options': [
        {'label': 'Original Box & Bill & Charger', 'adj': 2000},
        {'label': 'Box & Charger Only', 'adj': 1000},
        {'label': 'Device Only', 'adj': 0},
      ],
    },
  ];

  final int _basePrice = 64999;
  int _calculatedPrice = 61300;
  int _paymentMode = 0;

  // Step 2: Pickup details
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  String _selectedSlot = '10:00 AM – 1:00 PM';
  String _selectedDate = 'Tomorrow';

  @override
  void initState() {
    super.initState();
    _addressCtrl.text = widget.userProfile.address.isNotEmpty ? widget.userProfile.address : 'Gaur City, Delhi NCR - 201009';
    _phoneCtrl.text = widget.userProfile.phone.isNotEmpty ? widget.userProfile.phone : '9967853364';
    _recalculatePrice();
  }

  void _recalculatePrice() {
    int p = _basePrice;
    if (_selectedVariant == '256GB') p += 4000;
    if (_selectedVariant == '512GB') p += 9000;
    if (_selectedVariant == '1TB') p += 15000;

    for (int i = 0; i < _conditionQuestions.length; i++) {
      final optIdx = _conditionAnswers[i] ?? 0;
      final opts = _conditionQuestions[i]['options'] as List;
      final adj = opts[optIdx]['adj'] as int;
      p += adj;
    }
    setState(() => _calculatedPrice = p);
  }

  void _confirmAndCreateOrder() async {
    final order = UserOrder.fromJson({
      'id': 'ord-${DateTime.now().millisecondsSinceEpoch}',
      'orderNumber': 'CSM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'type': 'sell',
      'device': '$_selectedBrand $_selectedModelName ($_selectedVariant • $_selectedColor)',
      'amount': _calculatedPrice,
      'createdAt': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      'status': 'Pickup Scheduled',
      'customerAddress': '${_addressCtrl.text.trim().isEmpty ? "Registered Address" : _addressCtrl.text.trim()} ($_selectedSlot, $_selectedDate)',
      'paymentMethod': _paymentMode == 0 ? 'Instant UPI' : 'Bank Transfer',
    });

    widget.onOrderCreated(order);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order created! Guaranteed valuation: ${formatCurrency(_calculatedPrice)} scheduled for pickup.'),
        backgroundColor: const Color(0xFF059669),
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
            // ── TOP HEADER TITLE & BADGE ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Sell Your ',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextSpan(
                              text: 'Device',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF6366F1),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Get the best price for your old device in just a few simple steps.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDDD6FE)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user_rounded, color: Color(0xFF6366F1), size: 16),
                      SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('100% Safe & Secure', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF312E81))),
                          Text('Instant Payment', style: TextStyle(fontSize: 9, color: Color(0xFF4338CA))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ── 4-STEP STEPPER (MATCHING REFERENCE EXACTLY) ──
            _buildStepperRow(),

            const SizedBox(height: 20),

            // ── STEP CONTENT ──
            if (_currentStep == 0) _buildStep0DeviceDetails(),
            if (_currentStep == 1) _buildStep1Condition(),
            if (_currentStep == 2) _buildStep2Pickup(),
            if (_currentStep == 3) _buildStep3Quote(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperRow() {
    return Row(
      children: [
        _buildStepBadge(1, 'Device Details', _currentStep >= 0, _currentStep == 0),
        _buildStepLine(_currentStep >= 1),
        _buildStepBadge(2, 'Condition', _currentStep >= 1, _currentStep == 1),
        _buildStepLine(_currentStep >= 2),
        _buildStepBadge(3, 'Pickup', _currentStep >= 2, _currentStep == 2),
        _buildStepLine(_currentStep >= 3),
        _buildStepBadge(4, 'Quote', _currentStep >= 3, _currentStep == 3),
      ],
    );
  }

  Widget _buildStepBadge(int num, String label, bool isReached, bool isActive) {
    Color bg = isReached ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0);
    Color textColor = isReached ? Colors.white : const Color(0xFF94A3B8);

    return Column(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.35), blurRadius: 6, offset: const Offset(0, 2))]
                : null,
          ),
          child: Center(
            child: Text(
              '$num',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? const Color(0xFF1E1B4B) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isFilled) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 14),
        color: isFilled ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
      ),
    );
  }

  // ── STEP 0: DEVICE DETAILS ──
  Widget _buildStep0DeviceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Select Device Type
        const Text(
          'Select Device Type',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_deviceTypes.length, (idx) {
              final d = _deviceTypes[idx];
              final isSelected = _selectedDeviceType == idx;
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () => setState(() => _selectedDeviceType = idx),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF5F3FF) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        if (isSelected)
                          const Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.check_circle_rounded, color: Color(0xFF6366F1), size: 14),
                          )
                        else
                          const SizedBox(height: 14),
                        Container(
                          width: 44,
                          height: 44,
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(d['img'] as String, fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          d['title'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          d['sub'] as String,
                          style: const TextStyle(fontSize: 8.5, color: Color(0xFF64748B)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 20),

        // 2. Select Brand
        const Text(
          'Select Brand',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _brands.map((b) {
            final isSelected = _selectedBrand == b;
            return InkWell(
              onTap: () {
                setState(() => _selectedBrand = b);
                _recalculatePrice();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 72,
                height: 52,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF5F3FF) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSelected)
                      const Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(Icons.check_circle_rounded, color: Color(0xFF6366F1), size: 10),
                        ),
                      ),
                    Text(
                      b,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // 3. Select Model
        const Text(
          'Select Model',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedModelName,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
              items: _modelsList.map((m) {
                return DropdownMenuItem(
                  value: m,
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        padding: const EdgeInsets.all(2),
                        child: Image.asset('assets/images/refurbished/iphone-15-pro.png', fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 10),
                      Text(m, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedModelName = val);
                  _recalculatePrice();
                }
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 4. Select Variant
        const Text(
          'Select Variant',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),
        Row(
          children: _variants.map((v) {
            final isSelected = _selectedVariant == v;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () {
                    setState(() => _selectedVariant = v);
                    _recalculatePrice();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF5F3FF) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        v,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // 5. Select Color
        const Text(
          'Select Color',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),
        Row(
          children: _colors.map((c) {
            final name = c['name'] as String;
            final isSelected = _selectedColor == name;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => setState(() => _selectedColor = name),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF5F3FF) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        if (isSelected)
                          const Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.check_circle_rounded, color: Color(0xFF6366F1), size: 12),
                          )
                        else
                          const SizedBox(height: 12),
                        Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(2),
                          child: Image.asset(c['img'] as String, fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF1E293B),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // CTA: Next Check Device Condition
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _currentStep = 1),
            icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
            label: const Text(
              'Next: Check Device Condition',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  // ── STEP 1: CONDITION ──
  Widget _buildStep1Condition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Device Condition Checklist',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12)),
              child: Text(
                'Quote: ${formatCurrency(_calculatedPrice)}',
                style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_conditionQuestions.length, (qIdx) {
          final q = _conditionQuestions[qIdx];
          final opts = q['options'] as List;
          final selOpt = _conditionAnswers[qIdx] ?? 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
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
                  '${qIdx + 1}. ${q['title']}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 10),
                ...List.generate(opts.length, (optIdx) {
                  final isOptSel = selOpt == optIdx;
                  return InkWell(
                    onTap: () {
                      setState(() => _conditionAnswers[qIdx] = optIdx);
                      _recalculatePrice();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isOptSel ? const Color(0xFFF5F3FF) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isOptSel ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isOptSel ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isOptSel ? const Color(0xFF6366F1) : const Color(0xFF94A3B8),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              opts[optIdx]['label'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isOptSel ? FontWeight.bold : FontWeight.w500,
                                color: const Color(0xFF1E293B),
                              ),
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
        }),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep = 0),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Back', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => setState(() => _currentStep = 2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Next: Schedule Pickup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── STEP 2: PICKUP DETAILS ──
  Widget _buildStep2Pickup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Doorstep Inspection & Pickup Slot',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
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
              TextField(
                controller: _addressCtrl,
                decoration: InputDecoration(
                  labelText: 'Doorstep Pickup Address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF6366F1)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneCtrl,
                decoration: InputDecoration(
                  labelText: 'Contact Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF6366F1)),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Select Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: ['Today', 'Tomorrow', 'In 2 Days'].map((d) {
                  final isSel = _selectedDate == d;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      child: InkWell(
                        onTap: () => setState(() => _selectedDate = d),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFFF5F3FF) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSel ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            d,
                            style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.w500, color: isSel ? const Color(0xFF6366F1) : const Color(0xFF334155)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              const Text('Select Time Slot', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: ['10:00 AM – 1:00 PM', '2:00 PM – 5:00 PM', '6:00 PM – 9:00 PM'].map((s) {
                  final isSel = _selectedSlot == s;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      child: InkWell(
                        onTap: () => setState(() => _selectedSlot = s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFFF5F3FF) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSel ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            s.split(' – ').first,
                            style: TextStyle(fontSize: 11, fontWeight: isSel ? FontWeight.bold : FontWeight.w500, color: isSel ? const Color(0xFF6366F1) : const Color(0xFF334155)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep = 1),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Back', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => setState(() => _currentStep = 3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('View Guaranteed Valuation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── STEP 3: QUOTE & CONFIRMATION ──
  Widget _buildStep3Quote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: Column(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 48),
              const SizedBox(height: 10),
              const Text('Guaranteed Instant Payout', style: TextStyle(fontSize: 13, color: Color(0xFF065F46), fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                formatCurrency(_calculatedPrice),
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xFF064E3B), letterSpacing: -0.5),
              ),
              const SizedBox(height: 4),
              const Text('Transferred directly to UPI or Bank upon physical verification', style: TextStyle(fontSize: 11, color: Color(0xFF047857)), textAlign: TextAlign.center),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
              const Text('Summary of Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildSummaryRow('Device', '$_selectedBrand $_selectedModelName'),
              _buildSummaryRow('Variant & Color', '$_selectedVariant • $_selectedColor'),
              _buildSummaryRow('Pickup Slot', '$_selectedDate, $_selectedSlot'),
              _buildSummaryRow('Address', _addressCtrl.text.trim()),
              _buildSummaryRow('Contact', _phoneCtrl.text.trim()),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _confirmAndCreateOrder,
            icon: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
            label: const Text('Confirm & Schedule Free Pickup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
