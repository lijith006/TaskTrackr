import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_trackr/core/constants/app_strings.dart';
import 'package:task_trackr/core/constants/app_theme.dart';
import 'package:task_trackr/core/widgets/custom_button.dart';
import 'package:task_trackr/core/widgets/custom_text_form.dart';
import 'package:task_trackr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_trackr/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_trackr/features/auth/presentation/bloc/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirmPass = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (state is AuthFailure) {
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
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSurface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    Container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Create\naccount.',
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
                      'Start managing your tasks today',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: _email,
                            label: AppStrings.emailHint,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) => v != null && v.contains('@')
                                ? null
                                : 'Enter a valid email',
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: _pass,
                            label: AppStrings.passwordHint,
                            icon: Icons.lock_outline,
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) => v != null && v.length >= 6
                                ? null
                                : 'Minimum 6 characters',
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: _confirmPass,
                            label: 'Confirm Password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) => v == _pass.text
                                ? null
                                : 'Passwords do not match',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final loading = state is AuthLoading;
                        return CustomButton(
                          text: AppStrings.signUp,
                          isLoading: loading,
                          onPressed: () {
                            if (_form.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthSignup(
                                  _email.text.trim(),
                                  _pass.text.trim(),
                                ),
                              );
                            }
                          },
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
                            'Already have an account?',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Sign in',
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
