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
import 'exchange/exchange_workflow_screen.dart';
import 'home/home_screen.dart';
import 'profile/user_profile_screen.dart';
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
      _currentIndex = 1;
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
        preferredSize: const Size.fromHeight(62),
        child: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          elevation: 0,
          titleSpacing: 16,
          title: InkWell(
            onTap: () => setState(() => _currentIndex = 0),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset(
                        'assets/images/app_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'MAA ',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5),
                          ),
                          TextSpan(
                            text: 'AMBIKA',
                            style: TextStyle(
                              color: Color(0xFF34D399),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: _openLocationPicker,
                      child: Row(
                        children: [
                          const Icon(Icons.place, color: Color(0xFF34D399), size: 12),
                          const SizedBox(width: 2),
                          Text(
                            '$_selectedArea, $_selectedCity',
                            style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 16),
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
              icon: const Icon(Icons.location_on_outlined, color: Colors.white70, size: 22),
              tooltip: 'Select Location',
              onPressed: _openLocationPicker,
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white70, size: 22),
              tooltip: 'Notifications',
              onPressed: _showNotificationsDialog,
            ),
            const SizedBox(width: 4),
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
            onNavigateToBuy: () => setState(() => _currentIndex = 2),
            onNavigateToExchange: () => setState(() => _currentIndex = 3),
          ),
          SellWorkflowWidget(
            categories: _categories,
            preselectedCategory: _preselectedSellCategory,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
          ),
          BuyRefurbishedWidget(
            products: _refurbishedProducts,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
          ),
          ExchangeWorkflowWidget(
            refurbishedProducts: _refurbishedProducts,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
          ),
          UserProfileWidget(
            profile: widget.userProfile,
            orders: _orders,
            onProfileUpdate: widget.onProfileUpdate,
            onLogout: widget.onLogout,
            onNavigateToSell: () => setState(() => _currentIndex = 1),
            onNavigateToBuy: () => setState(() => _currentIndex = 2),
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
