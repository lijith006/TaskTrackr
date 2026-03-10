import 'package:flutter/material.dart';
import 'package:task_trackr/core/constants/app_theme.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  const TaskDetailsScreen({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
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
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Hero(
        tag: "task_$id",
        child: Material(
          color: Colors.transparent,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (isCompleted ? AppTheme.accent : AppTheme.warning)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (isCompleted ? AppTheme.accent : AppTheme.warning)
                          .withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked,
                        size: 14,
                        color: isCompleted ? AppTheme.accent : AppTheme.warning,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isCompleted ? 'Completed' : 'Pending',
                        style: TextStyle(
                          color: isCompleted
                              ? AppTheme.accent
                              : AppTheme.warning,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isCompleted
                        ? AppTheme.textMuted
                        : AppTheme.textPrimary,
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: AppTheme.textMuted,
                    height: 1.3,
                    letterSpacing: -0.3,
                  ),
                ),

                if (description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DESCRIPTION',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
