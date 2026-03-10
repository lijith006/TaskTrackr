import 'package:task_trackr/features/tasks/domain/repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;
  DeleteTask(this.repository);

  Future<void> call(String id) {
    return repository.deleteTask(id);
  }
}
