import 'package:firebase_auth/firebase_auth.dart';

import 'logging_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<UserCredential> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e, stackTrace) {
      LoggingService.logError('Error signing in anonymously', e, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e, stackTrace) {
      LoggingService.logError('Error signing out', e, stackTrace);
      rethrow;
    }
  }

  String? get currentUserId => _auth.currentUser?.uid;
}