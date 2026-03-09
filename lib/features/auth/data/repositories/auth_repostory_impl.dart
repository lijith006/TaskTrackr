import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_trackr/features/auth/domain/repository/auth_repository.dart';
import '../datasources/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthRepositoryImpl(this.authService);

  @override
  Future<User?> signInWithGoogle() {
    return authService.signInWithGoogle();
  }

  @override
  Future<User?> signInWithEmail(String email, String password) {
    return authService.signInWithEmail(email, password);
  }

  @override
  Future<User?> signUpWithEmail(String email, String password) {
    return authService.signUpWithEmail(email, password);
  }

  @override
  Future<void> signOut() {
    return authService.signOut();
  }

  @override
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  @override
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }
}
