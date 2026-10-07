import 'dart:async';
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/in_app_update_service.dart';
import 'core/services/storage_service.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await StorageService.init();

    // Check for in-app updates on Android release builds
    InAppUpdateService.checkForUpdate();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('MaaAmbikaPartner Error: ${details.exception}');
    };

    runApp(const MaaAmbikaPartnerApp());
  }, (error, stack) {
    debugPrint('MaaAmbikaPartner Uncaught: $error\n$stack');
  });
}
