import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'modules/navigation/delivery_main_navigation_screen.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<ScaffoldMessengerState> deliveryScaffoldMessengerKey = scaffoldMessengerKey;

class MaaAmbikaDeliveryApp extends StatelessWidget {
  const MaaAmbikaDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          primary: AppConstants.primaryColor,
          secondary: AppConstants.secondaryColor,
          surface: AppConstants.surfaceColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppConstants.scaffoldBackgroundColor,
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          color: AppConstants.cardColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.appBarDark,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const DeliveryMainNavigationScreen(),
    );
  }
}

// Backward-compatibility alias
typedef CamsikDeliveryApp = MaaAmbikaDeliveryApp;
