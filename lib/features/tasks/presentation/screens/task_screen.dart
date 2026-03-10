import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_trackr/core/constants/app_theme.dart';
import 'package:task_trackr/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_trackr/features/tasks/presentation/bloc/task_event.dart';
import 'package:task_trackr/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_trackr/features/tasks/presentation/widgets/add_task_bottom_sheet.dart';
import 'package:task_trackr/features/tasks/presentation/widgets/delete_dialogue.dart';
import 'package:task_trackr/features/tasks/presentation/widgets/logout_bottom_sheet.dart';
import 'package:task_trackr/features/tasks/presentation/widgets/task_card.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskActionSuccess) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.success,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(state.message),
                  ],
                ),
                backgroundColor: AppTheme.elevated,
              ),
            );
          } else if (state is TaskError) {
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 13,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'My Tasks',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Profile icon -logout
                    GestureDetector(
                      onTap: () => LogoutBottomSheet.show(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.cardSurface,
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Add Task
                    GestureDetector(
                      onTap: () => _showAddSheet(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(99),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              //  Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardSurface,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(
                            Icons.search_rounded,
                            color: AppTheme.textMuted,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 15,
                            ),
                            cursorColor: AppTheme.primary,
                            onChanged: (value) => setState(
                              () => searchQuery = value.toLowerCase(),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Search tasks...',
                              hintStyle: TextStyle(color: AppTheme.textMuted),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //  Stats row
              BlocBuilder<TaskBloc, TaskState>(
                buildWhen: (prev, curr) => curr is TaskLoaded,
                builder: (context, state) {
                  if (state is TaskLoaded) {
                    final tasks = state.tasks
                        .where(
                          (t) => t.title.toLowerCase().contains(searchQuery),
                        )
                        .toList();
                    final pending = tasks.where((t) => !t.isCompleted).length;
                    final completed = tasks.where((t) => t.isCompleted).length;
                    final total = tasks.length;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _StatChip(
                            label: 'Pending',
                            count: '$pending',
                            color: AppTheme.warning,
                          ),
                          const SizedBox(width: 10),
                          _StatChip(
                            label: 'Done',
                            count: '$completed/$total',
                            color: AppTheme.accent,
                          ),
                          if (total > 0) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value: completed / total,
                                  backgroundColor: AppTheme.elevated,
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppTheme.accent,
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 12),

              //  Task list
              Expanded(
                child: BlocBuilder<TaskBloc, TaskState>(
                  buildWhen: (prev, curr) =>
                      curr is TaskLoaded || curr is TaskLoading,
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primary,
                          strokeWidth: 2,
                        ),
                      );
                    } else if (state is TaskLoaded) {
                      final tasks = state.tasks
                          .where(
                            (t) => t.title.toLowerCase().contains(searchQuery),
                          )
                          .toList();

                      if (tasks.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppTheme.cardSurface,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.border),
                                ),
                                child: const Icon(
                                  Icons.checklist_rounded,
                                  size: 40,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No tasks yet',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Tap 'Add' to get started",
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final t = tasks[index];
                          return TaskCard(
                            id: t.id,
                            key: ValueKey(t.id),
                            title: t.title,
                            description: t.description,
                            isCompletd: t.isCompleted,
                            onToggle: () {
                              context.read<TaskBloc>().add(
                                UpdateTaskEvent(
                                  t.copyWith(isCompleted: !t.isCompleted),
                                ),
                              );
                            },
                            onEdit: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<TaskBloc>(),
                                  child: AddTaskBottomSheet(task: t),
                                ),
                              );
                            },
                            onDelete: () {
                              showDeleteDialog(context, () {
                                context.read<TaskBloc>().add(
                                  DeleteTaskEvent(t.id),
                                );
                              });
                            },
                          );
                        },
                      );
                    } else if (state is TaskError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: AppTheme.danger),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<TaskBloc>(),
        child: const AddTaskBottomSheet(),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning ☀️';
    if (hour < 17) return 'Good afternoon 👋';
    return 'Good evening 🌙';
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              count,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
