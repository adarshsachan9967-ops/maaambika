import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'modules/navigation/partner_main_navigation_screen.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<ScaffoldMessengerState> partnerScaffoldMessengerKey = scaffoldMessengerKey;

class MaaAmbikaPartnerApp extends StatelessWidget {
  const MaaAmbikaPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          primary: AppConstants.primaryColor,
          surface: AppConstants.surfaceLight,
        ),
        scaffoldBackgroundColor: AppConstants.surfaceLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.darkBackground,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const PartnerMainNavigationScreen(),
    );
  }
}

typedef CamsikPartnerApp = MaaAmbikaPartnerApp;
