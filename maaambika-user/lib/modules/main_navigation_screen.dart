import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/services/api_service.dart';
import '../core/services/notification_service.dart';
import '../models/user_order.dart';
import '../models/user_profile.dart';
import '../widgets/maaambika_bottom_bar.dart';
import '../widgets/location_picker_sheet.dart';
import '../widgets/notification_bottom_sheet.dart';
import 'buy/buy_refurbished_screen.dart';
import 'home/home_screen.dart';
import 'profile/user_profile_screen.dart';
import 'repairs/repairs_workflow_screen.dart';
import 'sell/sell_workflow_screen.dart';

class UserMainNavigationScreen extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final VoidCallback onLogout;

  const UserMainNavigationScreen({
    super.key,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onLogout,
  });

  @override
  State<UserMainNavigationScreen> createState() => _UserMainNavigationScreenState();
}

class _UserMainNavigationScreenState extends State<UserMainNavigationScreen> {
  int _currentIndex = 0;
  String _selectedCity = AppConstants.defaultCity;
  String _selectedArea = AppConstants.defaultArea;

  List<Map<String, dynamic>> _banners = ApiService.cachedBanners;
  List<Map<String, dynamic>> _categories = ApiService.cachedCategories;
  List<Map<String, dynamic>> _refurbishedProducts = ApiService.cachedRefurbished;
  final List<UserOrder> _orders = [];

  String? _preselectedSellCategory;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    ApiService.syncDataInBackground().then((_) {
      if (mounted) {
        setState(() {
          _banners = ApiService.cachedBanners;
          _categories = ApiService.cachedCategories;
          _refurbishedProducts = ApiService.cachedRefurbished;
        });
      }
    });

    if (widget.userProfile.phone.isNotEmpty) {
      ApiService.fetchOrders(phone: widget.userProfile.phone).then((fetchedOrders) {
        if (mounted && fetchedOrders.isNotEmpty) {
          setState(() {
            _orders.clear();
            for (final o in fetchedOrders) {
              _orders.add(UserOrder.fromJson(o));
            }
          });
        }
      });
    }
  }

  void _navigateToSellWithCategory([String? catId]) {
    setState(() {
      _preselectedSellCategory = catId;
      _currentIndex = 2; // Tab 2 is Sell
    });
  }

  void _handleOrderCreated(UserOrder order) {
    setState(() {
      _orders.insert(0, order);
      _currentIndex = 4; // Navigate to Profile / My Orders
    });

    NotificationService.triggerNotification(
      context: context,
      title: 'Order Confirmed · ${order.orderNumber}',
      message: 'Your ${order.type.toUpperCase()} request for ${order.device} has been successfully scheduled.',
      orderId: order.orderNumber,
      onTapViewOrder: () {
        setState(() => _currentIndex = 4);
      },
    );
  }

  void _openLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return LocationPickerSheet(
          currentCity: _selectedCity,
          currentArea: _selectedArea,
          onLocationSelected: (city, area) {
            setState(() {
              _selectedCity = city;
              _selectedArea = area;
            });
          },
        );
      },
    );
  }

  void _showNotificationsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => const NotificationBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(66),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 16,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: const Color(0xFFF1F5F9), height: 1),
          ),
          title: InkWell(
            onTap: () => setState(() => _currentIndex = 0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/shop_emblem.png',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Image.asset(
                        'assets/images/app_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c2, e2, s2) => const Icon(Icons.storefront, color: Color(0xFF7C3AED), size: 24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'MAA AMBIKA',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFFFEDD5)),
                          ),
                          child: const Text(
                            'MOBILE SHOP',
                            style: TextStyle(
                              color: Color(0xFFEA580C),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    InkWell(
                      onTap: _openLocationPicker,
                      child: Row(
                        children: [
                          const Icon(Icons.place, color: Color(0xFFEA580C), size: 12),
                          const SizedBox(width: 2),
                          Text(
                            '$_selectedArea, $_selectedCity',
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B), size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded, color: Color(0xFF334155), size: 22),
              tooltip: 'Search Shop',
              onPressed: () => setState(() => _currentIndex = 1),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF334155), size: 22),
                  tooltip: 'Cart',
                  onPressed: () => setState(() => _currentIndex = 1),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEA580C),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '2',
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF334155), size: 22),
              tooltip: 'Notifications',
              onPressed: _showNotificationsDialog,
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            banners: _banners,
            categories: _categories,
            refurbishedProducts: _refurbishedProducts,
            onNavigateToSell: ([catId]) => _navigateToSellWithCategory(catId),
            onNavigateToBuy: () => setState(() => _currentIndex = 1),
            onNavigateToExchange: () => setState(() => _currentIndex = 2),
            onNavigateToRepairs: () => setState(() => _currentIndex = 3),
          ),
          BuyRefurbishedWidget(
            products: _refurbishedProducts,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
          ),
          SellWorkflowWidget(
            categories: _categories,
            preselectedCategory: _preselectedSellCategory,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
          ),
          RepairsWorkflowScreen(
            userProfile: widget.userProfile,
            onOrderCreated: _handleOrderCreated,
          ),
          UserProfileWidget(
            profile: widget.userProfile,
            orders: _orders,
            onProfileUpdate: widget.onProfileUpdate,
            onLogout: widget.onLogout,
            onNavigateToSell: () => setState(() => _currentIndex = 2),
            onNavigateToBuy: () => setState(() => _currentIndex = 1),
            onNavigateToRepairs: () => setState(() => _currentIndex = 3),
          ),
        ],
      ),
      bottomNavigationBar: MaaAmbikaBottomBar(
        selectedIndex: _currentIndex,
        onItemSelected: (idx) => setState(() => _currentIndex = idx),
      ),
    );
  }
}
