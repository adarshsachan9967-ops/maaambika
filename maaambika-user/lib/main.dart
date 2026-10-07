import 'dart:async';
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/session_service.dart';
import 'core/services/storage_service.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SharedPreferencesService.getInstance();
    await SessionService.init();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('MaaAmbikaUser Error: ${details.exception}');
    };

    runApp(const MaaAmbikaUserApp());
  }, (error, stack) {
    debugPrint('MaaAmbikaUser Uncaught: $error\n$stack');
  });
}
