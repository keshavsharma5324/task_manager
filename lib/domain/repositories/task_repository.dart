import 'package:task_manager/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(String title, String description);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}