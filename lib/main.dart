// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:task_trackr/core/constants/app_theme.dart';
// import 'package:task_trackr/features/auth/presentation/screens/login_screen.dart';
// import 'package:task_trackr/firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.darkTheme,
//       home:
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_trackr/core/constants/app_theme.dart';
import 'package:task_trackr/features/auth/domain/repository/auth_repository.dart';
import 'package:task_trackr/features/auth/presentation/screens/signup_screen.dart';
import 'package:task_trackr/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_trackr/features/tasks/presentation/screens/task_screen.dart';
import 'package:task_trackr/firebase_options.dart';

import 'package:task_trackr/features/auth/domain/usecases/login_with_email.dart';
import 'package:task_trackr/features/auth/domain/usecases/signup_with_email.dart';
import 'package:task_trackr/features/auth/domain/usecases/login_with_google.dart';
import 'package:task_trackr/features/auth/domain/usecases/logout.dart';

import 'package:task_trackr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_trackr/features/auth/presentation/screens/login_screen.dart';
import 'package:task_trackr/features/auth/data/datasources/auth_service_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Data source
  final authService = AuthServiceImpl();
  final repository = AuthRepositoryImpl(authService);

  /// Use cases
  final loginWithEmail = LoginWithEmail(repository);
  final signupWithEmail = SignupWithEmail(repository);
  final loginWithGoogle = LoginWithGoogle(repository);
  final logout = Logout(repository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginWithEmail: loginWithEmail,
            signupWithEmail: signupWithEmail,
            loginWithGoogle: loginWithGoogle,
            logout: logout,
          ),
        ),

        BlocProvider(create: (_) => TaskBloc()),
      ],
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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const TaskScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
