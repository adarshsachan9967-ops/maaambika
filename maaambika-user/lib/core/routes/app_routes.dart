import 'package:flutter/material.dart';

class AppRoutes {
  static const String initial = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String mainNavigation = '/main';
  static const String sell = '/sell';
  static const String buy = '/buy';
  static const String rent = '/rent';
  static const String exchange = '/exchange';
  static const String orders = '/orders';
  static const String profile = '/profile';

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
