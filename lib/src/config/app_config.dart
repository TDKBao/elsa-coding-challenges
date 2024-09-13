import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';

import '../services/logging_service.dart';
import 'constants.dart';

class AppConfig {
  static late FirebaseRemoteConfig remoteConfig;
  static Map<String, dynamic> _appConfigMap = {};
  static bool isInitialized = false;

  static Future<void> initialize() async {
    const env = String.fromEnvironment(AppConstants.ENV,
        defaultValue: Environment.staging);
    await _initAppRemoteConfig(env);
  }

  static Future<void> _initAppRemoteConfig(String env) async {
    final envFilePath = 'assets/env/app_config_$env.json';

    try {
      final localRawString = await rootBundle.loadString(envFilePath);
      final localValue = jsonDecode(localRawString);
      _appConfigMap = localValue;

      final defaultsMap = Map<String, dynamic>.from(_appConfigMap);
      defaultsMap.forEach((key, value) {
        if (value is! bool && value is! num && value is! String) {
          defaultsMap[key] = json.encode(value);
        }
      });

      remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setDefaults(defaultsMap);
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await remoteConfig.ensureInitialized();
      await remoteConfig.fetchAndActivate();

      final config = remoteConfig.getAll();
      final remoteValue = config.map(
        (key, value) => MapEntry<String, dynamic>(key, value.asString()),
      );
      _appConfigMap.addAll(remoteValue);
      isInitialized = true;
    } catch (e, stackTrace) {
      LoggingService.logError('Error initializing AppConfig', e, stackTrace);
      rethrow;
    }
  }

  static String? getStringValue(String key) {
    if (!isInitialized) {
      LoggingService.logWarning('AppConfig is not initialized');
      return null;
    }
    final value = _appConfigMap[key];
    if (value is String) {
      return value;
    } else if (value != null) {
      return json.encode(value);
    }
    return null;
  }
}
