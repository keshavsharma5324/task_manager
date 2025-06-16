import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required String id,
    required String title,
    required String description,
    required DateTime createdAt,
    required bool isCompleted,
    required String userId,
  }) : super(
    id: id,
    title: title,
    description: description,
    createdAt: createdAt,
    isCompleted: isCompleted,
    userId: userId,
  );

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }
}