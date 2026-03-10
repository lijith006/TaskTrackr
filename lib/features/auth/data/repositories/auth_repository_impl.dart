import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;

  AuthRepositoryImpl(this._service);

  @override
  Future<User?> signInWithGoogle() => _service.signInWithGoogle();

  @override
  Future<User?> signInWithEmail(String email, String password) =>
      _service.signInWithEmail(email, password);

  @override
  Future<User?> signUpWithEmail(String email, String password) =>
      _service.signUpWithEmail(email, password);

  @override
  Future<void> signOut() => _service.signOut();

  @override
  User? get currentUser => _service.currentUser;

  @override
  Stream<User?> authStateChanges() => _service.authStateChanges();
}
