import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/faq_section.dart';

class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> banners;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> refurbishedProducts;
  final Function([String? categoryId]) onNavigateToSell;
  final VoidCallback onNavigateToBuy;
  final VoidCallback onNavigateToExchange;
  final VoidCallback? onNavigateToRent;

  const HomeScreen({
    super.key,
    required this.banners,
    required this.categories,
    required this.refurbishedProducts,
    required this.onNavigateToSell,
    required this.onNavigateToBuy,
    required this.onNavigateToExchange,
    this.onNavigateToRent,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return _buildHomeScreen();
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. FULL-WIDTH INFINITE LOOPING BANNER (PROPER TOP SPACING, NEVER TOUCHING HEADER)
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 8),
            child: MaaAmbikaFullWidthBannerCarousel(
              banners: widget.banners,
              onBannerTap: (catId) => widget.onNavigateToSell(catId),
            ),
          ),

          const SizedBox(height: 10),

          // 2. THREE SERVICE CARDS (MATCHING REFERENCE IMAGE 1: SELL, BUY, REPAIR)
          _buildThreeServiceCards(),

          const SizedBox(height: 24),

          // 3. EXPLORE 8 TECH CATEGORIES
          _buildEightCategoriesBar(),

          const SizedBox(height: 24),

          // 4. TOP REFURBISHED DEALS
          _buildTopDealsShowcase(),

          const SizedBox(height: 24),

          // 5. MAA AMBIKA TRUST SCORECARD
          _buildTrustScorecard(),

          const SizedBox(height: 24),

          // 6. 6-STEP BUYBACK WORKFLOW (MATCHING REFERENCE IMAGE 3)
          _buildSixStepBuybackSection(),

          const SizedBox(height: 24),

          // 7. REAL CUSTOMER REVIEWS (MATCHING REFERENCE IMAGE 4)
          _buildCustomerFeedbackSection(),

          const SizedBox(height: 24),

          // 8. WHY MAA AMBIKA
          _buildWhyMaaAmbikaSection(),

          const SizedBox(height: 24),

          // 9. FAQS & GUARANTEES (FULL 10 FAQS WITH CATEGORY TABS)
          const MaaAmbikaFaqSectionWidget(),
        ],
      ),
    );
  }



  // 3. 8 TECH CATEGORIES
  Widget _buildEightCategoriesBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore Tech Categories',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    'Sell or upgrade across 8 device categories',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => widget.onNavigateToSell(),
                child: const Text('View All', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 118,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: widget.categories.length,
            itemBuilder: (ctx, idx) {
              final cat = widget.categories[idx];
              final catId = cat['id']?.toString() ?? '';
              final catName = cat['name']?.toString() ?? '';
              final catImg = cat['image']?.toString() ?? 'assets/images/categories/smartphone.png';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  onTap: () => widget.onNavigateToSell(catId),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 88,
                    padding: const EdgeInsets.all(8),
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
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(
                              catImg,
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 28, color: Color(0xFF059669)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          catName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.1),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 4. TOP REFURBISHED DEALS
  Widget _buildTopDealsShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Certified Refurbished Deals',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    '45-Point certified · 12 months warranty · 90%+ battery',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => widget.onNavigateToBuy(),
                child: const Text('Shop All', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 235,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: widget.refurbishedProducts.length,
            itemBuilder: (ctx, idx) {
              final p = widget.refurbishedProducts[idx];
              final name = p['model']?.toString() ?? p['name']?.toString() ?? 'Device';
              final price = (p['sellingPrice'] as num?)?.toInt() ?? (p['price'] as num?)?.toInt() ?? 0;
              final origPrice = (p['originalPrice'] as num?)?.toInt() ?? (price > 0 ? (price * 1.3).round() : 0);
              final discount = (p['discount'] as num?)?.toInt() ?? 
                  (origPrice > price && origPrice > 0 ? (((origPrice - price) / origPrice) * 100).round() : 15);
              final battery = p['batteryHealth']?.toString() ?? '90%+';
              final image = p['image']?.toString() ?? 'assets/images/categories/smartphone.png';

              return Container(
                width: 170,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
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
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$discount% OFF',
                            style: const TextStyle(color: Color(0xFF059669), fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          battery,
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          image,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(Icons.devices, size: 40, color: Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 2),
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
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 5. MAA AMBIKA TRUST SCORECARD
  Widget _buildTrustScorecard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34D399).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_user, color: Color(0xFF34D399), size: 18),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Maa Ambika Quality & Trust Guarantee',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildTrustMetric('3,20,000+', 'Devices Rehomed'),
                _buildTrustMetric('4.8 / 5.0', 'Google Rating'),
                _buildTrustMetric('15 Mins', 'Spot UPI Payout'),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF38BDF8), size: 16),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'DoD 5220.22-M military-grade certified data wipe on every device before handover.',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustMetric(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 16),
          ),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        ],
      ),
    );
  }

  // 2. THREE SERVICE CARDS (MATCHING REFERENCE IMAGE 1: SELL, BUY, REPAIR)
  Widget _buildThreeServiceCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Heading
          const Text(
            'Sell, Buy & Repair Devices',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),

          // CARD 1: SELL YOUR DEVICE (GREEN)
          _buildServiceCardItem(
            titlePrefix: 'Sell ',
            titleHighlight: 'Your Device',
            highlightColor: const Color(0xFF059669),
            subtitle: 'Get the best value for your old devices in 60 seconds.',
            buttonText: 'Get Device Value',
            buttonColor: const Color(0xFF059669),
            icon: Icons.local_offer_outlined,
            iconBg: const Color(0xFFECFDF5),
            features: [
              'Best Price Guaranteed',
              'Free Doorstep Pickup',
              'Instant Payment',
              '100% Safe & Secure',
            ],
            imagePath: 'assets/images/categories/smartphone.png',
            proofText: '50,000+ devices sold last month',
            onTap: () => widget.onNavigateToSell(),
          ),
          const SizedBox(height: 12),

          // CARD 2: BUY REFURBISHED (BLUE)
          _buildServiceCardItem(
            titlePrefix: 'Buy ',
            titleHighlight: 'Refurbished',
            highlightColor: const Color(0xFF2563EB),
            subtitle: 'Certified, tested and reliable devices at the best prices.',
            buttonText: 'Explore Devices',
            buttonColor: const Color(0xFF2563EB),
            icon: Icons.shopping_bag_outlined,
            iconBg: const Color(0xFFEFF6FF),
            features: [
              '32 Point Quality Check',
              '6 Months Warranty',
              'Easy Returns',
              'Best Market Prices',
            ],
            imagePath: 'assets/images/categories/laptop.png',
            proofText: '10,000+ happy buyers',
            onTap: () => widget.onNavigateToBuy(),
          ),
          const SizedBox(height: 12),

          // CARD 3: REPAIR YOUR DEVICE (PURPLE)
          _buildServiceCardItem(
            titlePrefix: 'Repair ',
            titleHighlight: 'Your Device',
            highlightColor: const Color(0xFF7C3AED),
            subtitle: 'Expert repair services with original parts & warranty.',
            buttonText: 'Book a Repair',
            buttonColor: const Color(0xFF7C3AED),
            icon: Icons.build_outlined,
            iconBg: const Color(0xFFF5F3FF),
            features: [
              'Screen & Battery Repair',
              'Original Parts Used',
              'Expert Technicians',
              'Warranty on Repair',
            ],
            imagePath: 'assets/images/categories/dslr.png',
            proofText: '25,000+ repairs completed',
            onTap: () => widget.onNavigateToSell(),
          ),
          const SizedBox(height: 14),

          // SUBTLE TRUST STRIP BELOW CARDS (Reference Image 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTrustMiniPill(icon: Icons.local_shipping_outlined, label: 'Free Pickup', color: const Color(0xFF059669)),
                _buildTrustMiniPill(icon: Icons.bolt_outlined, label: 'Instant Pay', color: const Color(0xFFD97706)),
                _buildTrustMiniPill(icon: Icons.shield_outlined, label: '100% Safe', color: const Color(0xFF2563EB)),
                _buildTrustMiniPill(icon: Icons.headset_mic_outlined, label: '24/7 Helpline', color: const Color(0xFFDC2626)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCardItem({
    required String titlePrefix,
    required String titleHighlight,
    required Color highlightColor,
    required String subtitle,
    required String buttonText,
    required Color buttonColor,
    required IconData icon,
    required Color iconBg,
    required List<String> features,
    required String imagePath,
    required String proofText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Pill
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(icon, color: highlightColor, size: 20)),
          ),
          const SizedBox(height: 12),

          // Title & Subtitle + Image Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: titlePrefix,
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: titleHighlight,
                            style: TextStyle(
                              color: highlightColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Image.asset(
                  imagePath,
                  height: 55,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Icon(Icons.devices, size: 40, color: highlightColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Features Checklist
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, size: 14, color: highlightColor),
                    const SizedBox(width: 6),
                    Text(
                      f,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 12),

          // Button
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1,
              ),
              onPressed: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(buttonText, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 15),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Social Proof
          Row(
            children: [
              const Icon(Icons.verified, size: 13, color: Color(0xFF059669)),
              const SizedBox(width: 4),
              Text(
                proofText,
                style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 6. 6-STEP BUYBACK WORKFLOW (MATCHING REFERENCE IMAGE 3)
  Widget _buildSixStepBuybackSection() {
    final sixSteps = [
      {'num': '01', 'title': 'Get Instant Quote', 'desc': 'Search device & answer simple diagnostic questions.'},
      {'num': '02', 'title': 'Schedule Pickup', 'desc': 'Choose convenient date & slot for free doorstep visit.'},
      {'num': '03', 'title': 'Device Inspection', 'desc': 'Technician inspects device on-spot with QR code pass.'},
      {'num': '04', 'title': 'Get Best Offer', 'desc': 'Final price offer based on test with zero hidden cuts.'},
      {'num': '05', 'title': 'Secure Data Wipe', 'desc': '100% military-grade DoD sanitization for your privacy.'},
      {'num': '06', 'title': 'Instant Payment', 'desc': 'Receive spot UPI or bank transfer right at your door.'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bolt, size: 12, color: Color(0xFF2563EB)),
                    SizedBox(width: 4),
                    Text(
                      'SIMPLE. FAST. SECURE.',
                      style: TextStyle(color: Color(0xFF2563EB), fontSize: 9, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'How Maa Ambika Buyback Works',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),
          ...sixSteps.map((s) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          s['num']!,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['title']!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s['desc']!,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // 7. REAL CUSTOMER REVIEWS (MATCHING REFERENCE IMAGE 4)
  Widget _buildCustomerFeedbackSection() {
    final reviews = [
      {'name': 'Nitin Gowda', 'city': 'BANGALORE', 'color': const Color(0xFFD97706), 'text': 'Flawless experience. Instant credit. No haggling whatsoever — exactly what I expected.'},
      {'name': 'Pawan Mishra', 'city': 'PUNE', 'color': const Color(0xFF059669), 'text': 'Excellent services! The pickup was too good and the security checking was professional.'},
      {'name': 'Ritu Sharma', 'city': 'JAIPUR', 'color': const Color(0xFFDC2626), 'text': 'Super easy process. Got a great price for my old Samsung. Will definitely use again!'},
      {'name': 'Vidyankit Official', 'city': 'HYDERABAD', 'color': const Color(0xFFDB2777), 'text': 'Sold my Realme GT Neo. Very smooth process, no negotiation unlike other apps. Highly recommend!'},
      {'name': 'Mayank Doshi', 'city': 'AHMEDABAD', 'color': const Color(0xFF4F46E5), 'text': 'Very prompt service and got a very good price. Absolutely hassle-free.'},
      {'name': 'Aakash Mehta', 'city': 'CHENNAI', 'color': const Color(0xFFDC2626), 'text': 'Loved the transparent pricing. No last minute deductions. Payment received in under 10 minutes.'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Real Feedback From Customers',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    'Thousands trust Maa Ambika Mobile Shop',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                    SizedBox(width: 4),
                    Text('4.9/5', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Color(0xFF0F172A))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 135,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: reviews.length,
              separatorBuilder: (c, i) => const SizedBox(width: 10),
              itemBuilder: (ctx, idx) {
                final r = reviews[idx];
                return Container(
                  width: 260,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: r['color'] is Color ? r['color'] as Color : const Color(0xFF059669),
                            child: Text(
                              (r['name']?.toString() ?? 'U').isNotEmpty ? (r['name']?.toString() ?? 'U').substring(0, 1) : 'U',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r['name']?.toString() ?? 'Verified Customer',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0F172A)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  r['city']?.toString() ?? 'India',
                                  style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.star, size: 11, color: Color(0xFFF59E0B)),
                              Icon(Icons.star, size: 11, color: Color(0xFFF59E0B)),
                              Icon(Icons.star, size: 11, color: Color(0xFFF59E0B)),
                              Icon(Icons.star, size: 11, color: Color(0xFFF59E0B)),
                              Icon(Icons.star, size: 11, color: Color(0xFFF59E0B)),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '“${r['text']}”',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF475569), height: 1.3),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 11, color: Color(0xFF059669)),
                          SizedBox(width: 4),
                          Text('Verified Customer', style: TextStyle(color: Color(0xFF059669), fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustMiniPill({required IconData icon, required String label, required Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
        ),
      ],
    );
  }



  // 7. WHY MAA AMBIKA
  Widget _buildWhyMaaAmbikaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why 3.2 Lakh+ Sellers Trust Maa Ambika',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),
            _buildWhyBullet('Guaranteed Best Market Price', 'AI pricing calculated from live nationwide second-hand market transactions.'),
            _buildWhyBullet('Zero Hidden Deductions', 'Transparent inspection criteria with objective condition grading.'),
            _buildWhyBullet('1-Step Doorstep Exchange', 'Seamlessly upgrade to certified refurbished devices with only net difference payable.'),
            _buildWhyBullet('Certified DoD Military Wipe', 'Permanent zero-recovery data erasure keeping your personal files 100% secure.'),
          ],
        ),
      ),
    );
  }

  Widget _buildWhyBullet(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF059669), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                Text(desc, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
