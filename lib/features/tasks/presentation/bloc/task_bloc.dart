import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_trackr/features/tasks/domain/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await repository.getTasks();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<AddTaskEvent>((event, emit) async {
      await repository.addTask(event.task);
      emit(TaskActionSuccess("Task added successfully"));

      add(LoadTasks());
    });

    on<UpdateTaskEvent>((event, emit) async {
      await repository.updateTask(event.task);
      emit(TaskActionSuccess("Task updated successfully"));

      final tasks = await repository.getTasks();
      emit(TaskLoaded(tasks));
    });

    on<DeleteTaskEvent>((event, emit) async {
      await repository.deleteTask(event.taskId);
      emit(TaskActionSuccess("Task deleted successfully"));

      add(LoadTasks());
    });
  }
}
