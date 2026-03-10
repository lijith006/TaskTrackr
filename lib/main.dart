import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_trackr/core/constants/app_theme.dart';
import 'package:task_trackr/features/auth/data/datasources/auth_service_impl.dart';
import 'package:task_trackr/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:task_trackr/features/auth/domain/usecases/login_with_email.dart';
import 'package:task_trackr/features/auth/domain/usecases/login_with_google.dart';
import 'package:task_trackr/features/auth/domain/usecases/logout.dart';
import 'package:task_trackr/features/auth/domain/usecases/signup_with_email.dart';
import 'package:task_trackr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_trackr/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_trackr/features/auth/presentation/screens/login_screen.dart';
import 'package:task_trackr/features/auth/presentation/screens/signup_screen.dart';
import 'package:task_trackr/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:task_trackr/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:task_trackr/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_trackr/features/tasks/presentation/bloc/task_event.dart';
import 'package:task_trackr/features/tasks/presentation/screens/task_screen.dart';
import 'package:task_trackr/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authService = AuthServiceImpl();
  final authRepository = AuthRepositoryImpl(authService);

  runApp(
    BlocProvider(
      create: (_) => AuthBloc(
        loginWithEmail: LoginWithEmail(authRepository),
        signupWithEmail: SignupWithEmail(authRepository),
        loginWithGoogle: LoginWithGoogle(authRepository),
        logout: Logout(authRepository),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthGate(),
      routes: {'/signup': (context) => const SignupScreen()},
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          return _buildTaskScreen(authState.user.uid);
        }

        // Loading
        if (authState is AuthLoading) {
          return const _LoadingScreen();
        }

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingScreen();
            }

            final user = snapshot.data;

            if (user != null) {
              // Session  active
              return _buildTaskScreen(user.uid);
            }

            // No session — show login
            return const LoginScreen();
          },
        );
      },
    );
  }

  Widget _buildTaskScreen(String uid) {
    final taskDataSource = TaskRemoteDataSource(userId: uid);
    final taskRepository = TaskRepositoryImpl(taskDataSource);

    return BlocProvider(
      create: (_) => TaskBloc(taskRepository)..add(LoadTasks()),
      child: const TaskScreen(),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: CircularProgressIndicator(
          color: AppTheme.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
