import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remote;

  TaskRepositoryImpl(this.remote);

  @override
  Future<List<Task>> getTasks() {
    return remote.getTasks();
  }

  @override
  Future<void> addTask(Task task) {
    return remote.addTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> updateTask(Task task) {
    return remote.updateTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) {
    return remote.deleteTask(id);
  }
}
