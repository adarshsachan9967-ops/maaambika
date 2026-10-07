import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
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
  int _step = 0; // 0: Category, 1: Brand/Model, 2: Variant, 3: Questions, 4: Summary, 5: Pickup Slot
  late Map<String, dynamic> _selectedCategory;
  List<Map<String, dynamic>> _models = [];
  Map<String, dynamic>? _selectedModel;
  String _selectedStorage = 'Body Only';
  String _selectedColor = 'Black';

  // Dynamic Questions from backend
  List<Map<String, dynamic>> _questions = [];
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> optionIndex

  int _basePrice = 58000;
  int _calculatedPrice = 58000;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();
  String _selectedSlot = '11:00 AM – 1:00 PM';
  String _selectedDate = 'Tomorrow';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.firstWhere(
      (c) => c['id'] == widget.preselectedCategory,
      orElse: () => widget.categories.isNotEmpty ? widget.categories.first : {'id': 'cat-dslr', 'name': 'DSLR & Mirrorless'},
    );
    _addressController.text = widget.userProfile.address;
    _upiController.text = widget.userProfile.upiId;
    _loadModelsForCategory(_selectedCategory['id'] as String);
  }

  void _loadModelsForCategory(String catId) {
    final syncModels = ApiService.getFallbackModelsSync(categoryId: catId);
    final syncQuestions = ApiService.getQuestionsSync(categoryId: catId);
    setState(() {
      _models = syncModels;
      _questions = syncQuestions;
      _selectedAnswers.clear();
      for (int i = 0; i < _questions.length; i++) {
        _selectedAnswers[i] = 0;
      }
    });
    _recalculatePrice();

    // Silent background fetch to update if online
    ApiService.fetchModels(categoryId: catId).then((models) {
      if (mounted && models.isNotEmpty) {
        setState(() => _models = models);
      }
    });
    ApiService.fetchQuestions(categoryId: catId).then((questions) {
      if (mounted && questions.isNotEmpty) {
        setState(() {
          _questions = questions;
          _selectedAnswers.clear();
          for (int i = 0; i < _questions.length; i++) {
            _selectedAnswers[i] = 0;
          }
        });
        _recalculatePrice();
      }
    });
  }

  void _recalculatePrice() {
    int price = _basePrice;
    for (int qIdx = 0; qIdx < _questions.length; qIdx++) {
      final optIdx = _selectedAnswers[qIdx] ?? 0;
      final options = _questions[qIdx]['options'] as List?;
      if (options != null && optIdx < options.length) {
        final adj = (options[optIdx]['adj'] as num?)?.toInt() ?? 0;
        price += adj;
      }
    }
    setState(() {
      _calculatedPrice = price > 3000 ? price : 3000;
    });
  }

  void _handleConfirmSellOrder() async {
    final orderData = {
      'type': 'sell',
      'customerName': widget.userProfile.name,
      'customerPhone': widget.userProfile.phone,
      'customerAddress': _addressController.text.trim(),
      'pickupDate': _selectedDate,
      'pickupSlot': _selectedSlot,
      'paymentMethod': 'Instant UPI (${_upiController.text.trim()})',
      'amount': _calculatedPrice,
      'deviceName': '${_selectedModel?['name'] ?? 'Device'} ($_selectedStorage)',
      'status': 'Order Placed',
    };

    final created = await ApiService.createOrder(orderData);
    if (created != null && mounted) {
      final userOrder = UserOrder.fromJson(created);
      widget.onOrderCreated(userOrder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getStepTitle(),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            if (_step > 0)
              Text(
                '${_selectedCategory['name']}${_selectedModel != null ? ' > ${_selectedModel!['name']}' : ''}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
              ),
          ],
        ),
        leading: _step > 0
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
        return 'Step 1 of 6: Select Category';
      case 1:
        return 'Step 2 of 6: Select Device Model';
      case 2:
        return 'Step 3 of 6: Storage & Variant';
      case 3:
        return 'Step 4 of 6: Device Condition';
      case 4:
        return 'Step 5 of 6: Valuation Summary';
      case 5:
        return 'Step 6 of 6: Schedule Pickup';
      default:
        return 'Sell Device';
    }
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildCategoryStep();
      case 1:
        return _buildModelStep();
      case 2:
        return _buildVariantStep();
      case 3:
        return _buildQuestionsStep();
      case 4:
        return _buildSummaryStep();
      case 5:
        return _buildPickupStep();
      default:
        return _buildCategoryStep();
    }
  }

  // Step 0: Category
  Widget _buildCategoryStep() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.15,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: widget.categories.length,
      itemBuilder: (ctx, idx) {
        final cat = widget.categories[idx];
        return InkWell(
          onTap: () {
            setState(() {
              _selectedCategory = cat;
              _step = 1;
            });
            _loadModelsForCategory(cat['id'] as String);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    cat['image'] as String,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 36, color: Color(0xFF059669)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['name'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Step 1: Model with REAL MODEL IMAGES
  Widget _buildModelStep() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _models.length,
      separatorBuilder: (c, i) => const SizedBox(height: 10),
      itemBuilder: (ctx, idx) {
        final m = _models[idx];
        final name = m['name'] as String;
        final brand = m['brand'] as String? ?? '';
        final basePrice = (m['basePrice'] as num?)?.toInt() ?? 50000;
        final image = m['image'] as String? ?? 'assets/images/categories/dslr.png';
        final specs = m['specs'] as String? ?? '';

        return InkWell(
          onTap: () {
            setState(() {
              _selectedModel = m;
              _basePrice = basePrice;
              final storages = m['storages'] as List?;
              if (storages != null && storages.isNotEmpty) {
                _selectedStorage = storages.first as String;
              }
              final colors = m['colors'] as List?;
              if (colors != null && colors.isNotEmpty) {
                _selectedColor = colors.first as String;
              }
              _step = 2;
            });
            _recalculatePrice();
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
                // Real Model Image
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 30, color: Color(0xFF94A3B8)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                      ),
                      if (brand.isNotEmpty)
                        Text(brand, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                      if (specs.isNotEmpty)
                        Text(
                          specs,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Up to', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    Text(
                      formatCurrency(basePrice),
                      style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF059669), fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Step 2: Variant & Configuration
  Widget _buildVariantStep() {
    final storages = (_selectedModel?['storages'] as List?)?.cast<String>() ?? ['Standard'];
    final colors = (_selectedModel?['colors'] as List?)?.cast<String>() ?? ['Standard Color'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Image.asset(
                  _selectedModel?['image'] as String? ?? 'assets/images/categories/dslr.png',
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 32, color: Color(0xFF94A3B8)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedModel?['name'] as String? ?? '',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      'Base Valuation: ${formatCurrency(_basePrice)}',
                      style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Select Storage / Configuration:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: storages.map((s) {
              final isSel = _selectedStorage == s;
              return ChoiceChip(
                label: Text(s),
                selected: isSel,
                onSelected: (val) => setState(() => _selectedStorage = s),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 12),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Select Color:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: colors.map((c) {
              final isSel = _selectedColor == c;
              return ChoiceChip(
                label: Text(c),
                selected: isSel,
                onSelected: (val) => setState(() => _selectedColor = c),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 12),
              );
            }).toList(),
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => setState(() => _step = 3),
              child: const Text('Proceed to Diagnostic Questions', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Category-Specific Diagnostic Questions
  Widget _buildQuestionsStep() {
    return Column(
      children: [
        // Live Price Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: const Color(0xFF0F172A),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Estimated Payout:', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
                '$kRupee ****',
                style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _questions.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (ctx, qIdx) {
              final q = _questions[qIdx];
              final qText = q['question'] as String;
              final options = (q['options'] as List?)?.cast<Map<String, dynamic>>() ?? [];
              final selectedOptIdx = _selectedAnswers[qIdx] ?? 0;

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
                      '${qIdx + 1}. $qText',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(options.length, (optIdx) {
                      final opt = options[optIdx];
                      final label = opt['label'] as String;
                      final sublabel = opt['sublabel'] as String? ?? '';
                      final adj = (opt['adj'] as num?)?.toInt() ?? 0;
                      final isSelected = selectedOptIdx == optIdx;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedAnswers[qIdx] = optIdx;
                          });
                          _recalculatePrice();
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF059669).withValues(alpha: 0.08) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 16,
                                color: isSelected ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    if (sublabel.isNotEmpty)
                                      Text(sublabel, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ),
                              if (adj != 0)
                                Text(
                                  adj > 0 ? '+$kRupee ****' : '-$kRupee ****',
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
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => setState(() => _step = 4),
              child: const Text('View Final Quote Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  // Step 4: Summary Breakdown
  Widget _buildSummaryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('Guaranteed Instant Payout Quote', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                const Text(
                  '$kRupee ****',
                  style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_selectedModel?['name']} ($_selectedStorage, $_selectedColor)',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Valuation Breakdown:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildBreakdownRow('Base Market Value', '$kRupee ****', isNeutral: true),
                const Divider(height: 16),
                ...List.generate(_questions.length, (qIdx) {
                  final optIdx = _selectedAnswers[qIdx] ?? 0;
                  final options = _questions[qIdx]['options'] as List?;
                  if (options == null || optIdx >= options.length) return const SizedBox.shrink();
                  final opt = options[optIdx];
                  final label = opt['label'] as String;
                  final adj = (opt['adj'] as num?)?.toInt() ?? 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                          ),
                        ),
                        Text(
                          adj == 0
                              ? '$kRupee 0'
                              : adj > 0
                                  ? '+$kRupee ****'
                                  : '-$kRupee ****',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: adj > 0
                                ? const Color(0xFF059669)
                                : adj < 0
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 16),
                _buildBreakdownRow('Final Handover Cash', '$kRupee ****', isHighlight: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => setState(() => _step = 5),
              child: const Text('Schedule Doorstep Handover', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, {bool isNeutral = false, bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isHighlight ? 13 : 12,
            fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w600,
            color: isHighlight ? const Color(0xFF0F172A) : const Color(0xFF475569),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 15 : 12,
            fontWeight: isHighlight ? FontWeight.w900 : FontWeight.bold,
            color: isHighlight ? const Color(0xFF059669) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  // Step 5: Pickup Details & Slots
  Widget _buildPickupStep() {
    final dates = ['Today', 'Tomorrow', 'Day After Tomorrow'];
    final slots = [
      '9:00 AM – 11:00 AM',
      '11:00 AM – 1:00 PM',
      '1:00 PM – 3:00 PM',
      '3:00 PM – 5:00 PM',
      '5:00 PM – 7:00 PM',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pickup Date:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: dates.map((d) {
              final isSel = _selectedDate == d;
              return ChoiceChip(
                label: Text(d),
                selected: isSel,
                onSelected: (v) => setState(() => _selectedDate = d),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Preferred Time Slot:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots.map((s) {
              final isSel = _selectedSlot == s;
              return ChoiceChip(
                label: Text(s),
                selected: isSel,
                onSelected: (v) => setState(() => _selectedSlot = s),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('Pickup Address:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _addressController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Enter complete flat, street and pincode',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Payment UPI ID:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _upiController,
            decoration: InputDecoration(
              hintText: 'e.g. mobile@upi or gpay',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              onPressed: _handleConfirmSellOrder,
              child: const Text('Confirm Doorstep Pickup Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
