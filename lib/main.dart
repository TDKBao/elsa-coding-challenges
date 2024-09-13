import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../firebase_options.dart';
import 'src/app.dart';
import 'src/config/app_config.dart';
import 'src/controllers/auth_controller.dart';
import 'src/services/analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await AppConfig.initialize();

  final analyticsService =
      AnalyticsService(); // Create AnalyticsService instance
  Get.put(AuthController());
  Get.put(analyticsService);
  runApp(const DemoApp());
}
