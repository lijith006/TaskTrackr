import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/signup_with_email.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/logout.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail loginWithEmail;
  final SignupWithEmail signupWithEmail;
  final LoginWithGoogle loginWithGoogle;
  final Logout logout;

  AuthBloc({
    required this.loginWithEmail,
    required this.signupWithEmail,
    required this.loginWithGoogle,
    required this.logout,
  }) : super(AuthInitial()) {
    on<AuthLoginWithEmail>(_onLoginRequested);
    on<AuthSignup>(_onSignupRequested);
    on<AuthLoginWithGoogle>(_onGoogleLoginRequested);
    on<AuthLogout>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(emailLoading: true));

    try {
      final User? user = await loginWithEmail(event.email, event.password);

      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthFailure("Login failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignupRequested(
    AuthSignup event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(emailLoading: true));

    try {
      final User? user = await signupWithEmail(event.email, event.password);

      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthFailure("Signup failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onGoogleLoginRequested(
    AuthLoginWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(googleLoading: true));

    try {
      final User? user = await loginWithGoogle();

      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthFailure("Google login failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    await logout();
    emit(AuthInitial());
  }
}
