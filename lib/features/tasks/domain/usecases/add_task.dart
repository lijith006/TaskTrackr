import 'package:task_trackr/features/tasks/domain/entities/task.dart';
import 'package:task_trackr/features/tasks/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;
  AddTask(this.repository);

  Future<void> call(Task task) {
    return repository.addTask(task);
  }
}
