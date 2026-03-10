import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Future<User?> signInWithGoogle();
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signUpWithEmail(String email, String password);
  Future<void> signOut();
  User? get currentUser;
  Stream<User?> authStateChanges();
}
