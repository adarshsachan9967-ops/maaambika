import 'package:flutter/material.dart';
import 'app_colors.dart';

export 'app_colors.dart';

class AppConstants {
  static const String appName = 'Maa Ambika Delivery';
  static const String fleetTitle = 'MAA AMBIKA FLEET';
  static const String appLogoPath = 'assets/images/app_logo.png';
  static const String currencySymbol = '₹';

  // Theme Colors forwarded from AppColors
  static const Color primaryColor = AppColors.primaryColor;
  static const Color primaryDark = AppColors.primaryDark;
  static const Color secondaryColor = AppColors.secondaryColor;
  static const Color surfaceColor = AppColors.surfaceColor;
  static const Color scaffoldBackgroundColor = AppColors.scaffoldBackgroundColor;
  static const Color cardColor = AppColors.cardColor;
  static const Color appBarDark = AppColors.appBarDark;

  // Status & Accent Colors
  static const Color successGreen = AppColors.successGreen;
  static const Color successGreenDark = AppColors.successGreenDark;
  static const Color warningAmber = AppColors.warningAmber;
  static const Color warningBg = AppColors.warningBg;
  static const Color errorRed = AppColors.errorRed;
  static const Color ratingGold = AppColors.ratingGold;
  static const Color borderSlate = AppColors.borderSlate;
  static const Color textDark = AppColors.textDark;
  static const Color textSlate = AppColors.textSlate;
  static const Color textMuted = AppColors.textMuted;

  // Shift & Target Defaults
  static const int defaultDailyTripTarget = 6;
  static const String demoRiderId = 'CAS-RD-8842';
  static const String demoRiderName = 'Rahul Sharma';
}
