abstract class AuthEvent {}

class AuthLoginWithEmail extends AuthEvent {
  final String email;
  final String password;

  AuthLoginWithEmail(this.email, this.password);
}

class AuthLoginWithGoogle extends AuthEvent {}

class AuthSignup extends AuthEvent {
  final String email;
  final String password;

  AuthSignup(this.email, this.password);
}

class AuthLogout extends AuthEvent {}
