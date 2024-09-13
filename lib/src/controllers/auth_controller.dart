import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/logging_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  Rxn<User?> firebaseUser = Rxn<User?>();

  @override
  void onInit() {
    firebaseUser.bindStream(_authService.user);
    super.onInit();
  }

  Future<void> signInAnonymously() async {
    try {
      await _authService.signInAnonymously();
            LoggingService.logInfo('User signed in anonymously');

    } catch (e, stackTrace) {
      LoggingService.logError('Error signing in anonymously', e, stackTrace);
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      LoggingService.logInfo('User signed out');
    } catch (e, stackTrace) {
      LoggingService.logError('Error signing out', e, stackTrace);
      Get.snackbar('Error', e.toString());
    }
  }

  String? get currentUserId => _authService.currentUserId;
}