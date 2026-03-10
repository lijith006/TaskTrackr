import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_trackr/core/constants/app_theme.dart';
import 'package:task_trackr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_trackr/features/auth/presentation/bloc/auth_event.dart';

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<AuthBloc>(),
        child: const LogoutBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName;
    final email = user?.email ?? '';

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.elevated,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 24),

          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary.withOpacity(0.12),
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                _initial(displayName, email),
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Name
          Text(
            displayName != null && displayName.isNotEmpty
                ? displayName
                : 'My Account',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            email,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
          ),

          const SizedBox(height: 24),
          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 20),

          // Sign out button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(AuthLogout());
              },
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text(
                'Sign Out',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.danger.withOpacity(0.12),
                foregroundColor: AppTheme.danger,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                  side: BorderSide(color: AppTheme.danger.withOpacity(0.3)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Cancel
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initial(String? name, String email) {
    if (name != null && name.isNotEmpty) return name[0].toUpperCase();
    if (email.isNotEmpty) return email[0].toUpperCase();
    return '?';
  }
}
