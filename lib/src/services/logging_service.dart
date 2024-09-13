import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class LoggingService {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  static void logInfo(String message) {
    _crashlytics.log('INFO: $message');
  }

  static void logWarning(String message) {
    _crashlytics.log('WARNING: $message');
  }

  static void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _crashlytics.log('ERROR: $message');
    _crashlytics.recordError(error ?? message, stackTrace);
  }
}