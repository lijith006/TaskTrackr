import 'package:task_trackr/features/tasks/domain/entities/task.dart';
import 'package:task_trackr/features/tasks/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;
  GetTasks(this.repository);

  Future<List<Task>> call() {
    return repository.getTasks();
  }
}
