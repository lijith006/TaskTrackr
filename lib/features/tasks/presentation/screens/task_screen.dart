import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_trackr/core/constants/app_theme.dart';
import 'package:task_trackr/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_trackr/features/tasks/presentation/bloc/task_event.dart';
import 'package:task_trackr/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_trackr/features/tasks/presentation/widgets/add_task_bottom_sheet.dart';
import 'package:task_trackr/features/tasks/presentation/widgets/delete_dialogue.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cutPosition = screenHeight * 0.3;

    return Scaffold(
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: ${state.message}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.3, 0.3],
              colors: [AppTheme.screenTop2, AppTheme.screenTopColor],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                //  Search + add button
                Positioned(
                  top: cutPosition - 75,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: '🚀 Search...',
                            hintStyle: TextStyle(color: AppTheme.greyText),
                            filled: true,
                            fillColor: AppTheme.searchField,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      //ADD button
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (bottomSheetContext) {
                              return BlocProvider.value(
                                value: context.read<TaskBloc>(),
                                child: const AddTaskBottomSheet(),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.buttonColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text('Add'),
                            SizedBox(width: 10),
                            Image.asset(
                              'assets/icons/plus.png',
                              width: 20,
                              height: 20,
                              color: AppTheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //  BlocBuilders
                Positioned.fill(
                  top: cutPosition,
                  child: Column(
                    children: [
                      //  BlocBuilder for- counts only
                      BlocBuilder<TaskBloc, TaskState>(
                        buildWhen: (prev, curr) => curr is TaskLoaded,
                        builder: (context, state) {
                          if (state is TaskLoaded) {
                            final tasks = state.tasks
                                .where(
                                  (t) => t.title.toLowerCase().contains(
                                    searchQuery,
                                  ),
                                )
                                .toList();

                            final pending = tasks
                                .where((t) => !t.isCompleted)
                                .toList();
                            final completed = tasks
                                .where((t) => t.isCompleted)
                                .toList();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Pending",
                                        style: TextStyle(
                                          color: AppTheme.buttonColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.darkLight,
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        height: 25,
                                        width: 30,
                                        child: Center(
                                          child: Text('${pending.length}'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Completed",
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.darkLight,
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        height: 25,
                                        width: 50,
                                        child: Center(
                                          child: Text(
                                            '${completed.length}/${tasks.length}',
                                            style: const TextStyle(
                                              color: AppTheme.onSurface,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      //  BlocBuilder for -task list
                      Expanded(
                        child: BlocBuilder<TaskBloc, TaskState>(
                          buildWhen: (prev, curr) => curr is TaskLoaded,
                          builder: (context, state) {
                            if (state is TaskLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is TaskLoaded) {
                              final tasks = state.tasks
                                  .where(
                                    (t) => t.title.toLowerCase().contains(
                                      searchQuery,
                                    ),
                                  )
                                  .toList();

                              if (tasks.isEmpty) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 30),
                                      Image.asset(
                                        'assets/icons/Clipboard.png',
                                        width: 150,
                                        height: 100,
                                        color: AppTheme.greyText,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: AppTheme.iconColorGrey,
                                            fontSize: 16,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "You don't have any tasks yet.",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "\n Start adding tasks and manage your\n time effectively",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  //final t = tasks[index];
                                  //Task card
                                  return SizedBox();
                                },
                              );
                            } else if (state is TaskError) {
                              return Center(
                                child: Text(
                                  'Error: ${state.message}',
                                  style: const TextStyle(color: Colors.red),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
