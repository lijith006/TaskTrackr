import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_trackr/core/constants/app_icons.dart';
import 'package:task_trackr/core/constants/app_theme.dart';
import 'package:task_trackr/core/widgets/custom_button.dart';
import 'package:task_trackr/core/widgets/custom_text_form.dart';
import 'package:task_trackr/core/widgets/validators.dart';
import 'package:task_trackr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_trackr/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_trackr/features/auth/presentation/bloc/auth_state.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.danger,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: AppTheme.elevated,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 40,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 56),

                    Container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'Welcome\nback.',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to continue to TaskTrackr',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 48),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: Validators.password,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final emailLoading = state is AuthLoading
                            ? state.emailLoading
                            : false;
                        return CustomButton(
                          text: 'Sign In',
                          isLoading: emailLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthLoginWithEmail(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppTheme.border)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppTheme.border)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final googleLoading = state is AuthLoading
                            ? state.googleLoading
                            : false;
                        return SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppTheme.border),
                              backgroundColor: AppTheme.cardSurface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: googleLoading
                                ? null
                                : () => context.read<AuthBloc>().add(
                                    AuthLoginWithGoogle(),
                                  ),
                            child: googleLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppTheme.primary,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppIcons.google,
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Continue with Google',
                                        style: TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SignupScreen(),
                              ),
                            ),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: AppTheme.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
