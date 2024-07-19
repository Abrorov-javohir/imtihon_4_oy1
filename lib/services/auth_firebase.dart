import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final authService = FirebaseAuth.instance;

  Future<void> login(String email, password, name) async {
    try {
      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      authService.currentUser?.updateDisplayName(name);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      await authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      authService.currentUser?.updateDisplayName(name);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }
}
