import 'package:task_trackr/features/auth/domain/repository/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<void> call() {
    return repository.signOut();
  }
}
