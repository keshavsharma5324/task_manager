import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';

class TaskUseCases {
  final TaskRepository repository;

  TaskUseCases(this.repository);

  // Create
  Future<void> addTask(String title, String description) async {
    if (title.isEmpty) throw ArgumentError('Title cannot be empty');
    return repository.addTask(title, description);
  }

  // Read
  Future<List<Task>> getTasks() async {
    return repository.getTasks();
  }

  // Update
  Future<void> updateTask(Task task) async {
    if (task.title.isEmpty) throw ArgumentError('Title cannot be empty');
    return repository.updateTask(task);
  }

  // Delete
  Future<void> deleteTask(String taskId) async {
    if (taskId.isEmpty) throw ArgumentError('Invalid task ID');
    return repository.deleteTask(taskId);
  }

  // Toggle completion status
  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      createdAt: task.createdAt,
      isCompleted: !task.isCompleted,
      userId: task.userId,
    );
    return repository.updateTask(updatedTask);
  }
}