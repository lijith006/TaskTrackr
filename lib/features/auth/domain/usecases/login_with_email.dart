import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_trackr/features/auth/domain/repository/auth_repository.dart';

class LoginWithEmail {
  final AuthRepository repository;

  LoginWithEmail(this.repository);

  Future<User?> call(String email, String password) {
    return repository.signInWithEmail(email, password);
  }
}
