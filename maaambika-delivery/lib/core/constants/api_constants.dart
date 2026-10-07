class ApiConstants {
  static const String serverUrl = 'https://api.maaambika.in';
  static const String baseUrl = 'https://api.maaambika.in/api/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';

  // Delivery rider endpoints
  static const String tasks = '/delivery/tasks';
  static const String taskStatusUpdate = '/delivery/tasks/status';
  static const String verifyOtp = '/delivery/tasks/verify-otp';
  static const String earnings = '/delivery/earnings';
  static const String instantPayout = '/delivery/payout/instant';
  static const String hotspots = '/delivery/hotspots';
  static const String hubs = '/delivery/hubs';
  static const String dutyStatus = '/delivery/duty-status';
  static const String profile = '/delivery/profile';
}
