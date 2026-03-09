import 'package:task_trackr/features/tasks/domain/entities/task.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  DeleteTaskEvent(this.taskId);
}
