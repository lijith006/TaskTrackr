import 'package:task_trackr/features/tasks/domain/entities/task.dart';
import 'package:task_trackr/features/tasks/domain/repositories/task_repository.dart';

class EditTask {
  final TaskRepository repository;
  EditTask(this.repository);

  Future<void> call(Task task) {
    return repository.updateTask(task);
  }
}
