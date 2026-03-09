import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_trackr/features/auth/domain/repository/auth_repository.dart';

class LoginWithGoogle {
  final AuthRepository repository;

  LoginWithGoogle(this.repository);

  Future<User?> call() {
    return repository.signInWithGoogle();
  }
}
