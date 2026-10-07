class ApiConstants {
  static const String serverUrl = 'https://api.maaambika.in';
  static const String baseUrl = 'https://api.maaambika.in/api/v1';

  // Auth endpoints
  static const String login = '/partner/auth/login';
  static const String refreshToken = '/auth/refresh-token';

  // Dashboard & Stats endpoints
  static const String dashboard = '/partner/dashboard';
  static const String partnerStats = '/partner/stats';

  // Orders endpoints
  static const String orders = '/partner/orders';
  static const String partnerOrders = '/partner/orders';

  // Inspection endpoints
  static const String inspections = '/partner/inspections';
  static const String partnerInspect = '/partner/inspections/submit';

  // Payouts endpoints
  static const String payouts = '/partner/payouts';
  static const String partnerPayout = '/partner/payouts/execute';

  // Profile endpoints
  static const String profile = '/partner/profile';
  static const String partnerProfile = '/partner/profile';
}
