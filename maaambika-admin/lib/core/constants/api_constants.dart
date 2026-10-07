class ApiConstants {
  static const String serverUrl = 'https://api.maaambika.in';
  static const String baseUrl = 'https://api.maaambika.in/api/v1';

  // Auth endpoints
  static const String login = '/admin/auth/login';
  static const String refreshToken = '/auth/refresh-token';

  // Overview / Dashboard endpoints
  static const String overview = '/admin/overview';
  static const String dashboardOverview = '/admin/overview';

  // Orders endpoints
  static const String orders = '/admin/orders';
  static const String adminOrders = '/admin/orders';
  static const String assignRider = '/admin/orders/assign';

  // Partners endpoints
  static const String partners = '/admin/partners';
  static const String adminPartners = '/admin/partners';
  static const String approveKyc = '/admin/partners/approve-kyc';

  // Marketing endpoints
  static const String coupons = '/admin/marketing/coupons';
  static const String adminCoupons = '/admin/marketing/coupons';
  static const String broadcast = '/admin/marketing/broadcast';
  static const String adminBroadcast = '/admin/marketing/broadcast';

  // Settings
  static const String settings = '/admin/settings';
  static const String adminSettings = '/admin/settings';
}
