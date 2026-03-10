import 'package:flutter/material.dart';
import 'package:task_trackr/core/constants/app_theme.dart';
import 'package:task_trackr/features/tasks/presentation/screens/task_details_screen.dart';

class TaskCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final bool isCompletd;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.isCompletd,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailsScreen(
              id: id,
              title: title,
              description: description,
              isCompleted: isCompletd,
            ),
          ),
        );
      },
      child: Hero(
        tag: "task_$id",
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCompletd
                  ? AppTheme.accent.withOpacity(0.3)
                  : AppTheme.border,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                GestureDetector(
                  onTap: onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompletd ? AppTheme.accent : Colors.transparent,
                      border: Border.all(
                        color: isCompletd
                            ? AppTheme.accent
                            : AppTheme.textMuted,
                        width: 1.5,
                      ),
                    ),
                    child: isCompletd
                        ? const Icon(
                            Icons.check,
                            size: 13,
                            color: AppTheme.background,
                          )
                        : null,
                  ),
                ),

                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isCompletd
                              ? AppTheme.textMuted
                              : AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: isCompletd
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: AppTheme.textMuted,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isCompletd
                                ? AppTheme.textMuted
                                : AppTheme.textSecondary,
                            fontSize: 13,
                            height: 1.4,
                            decoration: isCompletd
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Actions
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ActionIcon(
                      icon: Icons.edit_outlined,
                      color: AppTheme.primary,
                      onTap: onEdit,
                    ),
                    const SizedBox(height: 4),
                    _ActionIcon(
                      icon: Icons.delete_outline_rounded,
                      color: AppTheme.danger,
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
