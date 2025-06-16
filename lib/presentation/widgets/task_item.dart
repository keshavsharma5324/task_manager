import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/presentation/controllers/task_controller.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  final VoidCallback onEdit;

  final VoidCallback onDelete;

  const TaskItem({
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            // We can update the task status immediately
            final updatedTask = Task(
              id: task.id,
              title: task.title,
              description: task.description,
              createdAt: task.createdAt,
              isCompleted: value ?? task.isCompleted,
              userId: task.userId,
            );
            Get.find<TaskController>().updateTask(updatedTask);
          },
        ),
      ),
    );
  }
}
