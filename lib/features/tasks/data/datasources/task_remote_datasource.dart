import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskRemoteDataSource {
  final String userId;

  TaskRemoteDataSource({required this.userId});

  String get _baseUrl =>
      "https://task-trackr--to-do-app-default-rtdb.firebaseio.com/tasks/$userId";

  Future<List<TaskModel>> getTasks() async {
    final response = await http.get(Uri.parse("$_baseUrl.json"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data == null) return [];

      final List<TaskModel> tasks = [];
      (data as Map<String, dynamic>).forEach((key, value) {
        tasks.add(TaskModel.fromJson(value as Map<String, dynamic>, key));
      });
      return tasks;
    } else {
      throw Exception("Failed to load tasks (${response.statusCode})");
    }
  }

  Future<void> addTask(TaskModel task) async {
    final response = await http.put(
      Uri.parse("$_baseUrl/${task.id}.json"),
      body: json.encode(task.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to add task");
    }
  }

  Future<void> updateTask(TaskModel task) async {
    final response = await http.patch(
      Uri.parse("$_baseUrl/${task.id}.json"),
      body: json.encode(task.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update task");
    }
  }

  Future<void> deleteTask(String id) async {
    final response = await http.delete(Uri.parse("$_baseUrl/$id.json"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete task");
    }
  }
}
