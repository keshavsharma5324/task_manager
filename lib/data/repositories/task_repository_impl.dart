import 'package:task_manager/core/network/firebase_service.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {

  @override
  Future<List<Task>> getTasks() async {
    try {
      final user = FirebaseService.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final snapshot = await FirebaseService.firestore
          .collection('tasks')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<void> addTask(String title, String description) async {
    try {
      final user = FirebaseService.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final task = TaskModel(
        id: '', // Firestore will auto-generate ID
        title: title,
        description: description,
        createdAt: DateTime.now(),
        isCompleted: false,
        userId: user.uid,
      );

      await FirebaseService.firestore
          .collection('tasks')
          .add(task.toMap());
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      final user = FirebaseService.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');
      if (task.userId != user.uid) throw Exception('Unauthorized operation');

      await FirebaseService.firestore
          .collection('tasks')
          .doc(task.id)
          .update({
        'title': task.title,
        'description': task.description,
        'isCompleted': task.isCompleted,
      });
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final user = FirebaseService.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Verify task ownership before deletion
      final doc = await FirebaseService.firestore
          .collection('tasks')
          .doc(taskId)
          .get();

      if (!doc.exists) throw Exception('Task not found');
      if (doc.data()?['userId'] != user.uid) throw Exception('Unauthorized');

      await FirebaseService.firestore
          .collection('tasks')
          .doc(taskId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}