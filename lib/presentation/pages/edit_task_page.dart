import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/utils/constants.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/presentation/controllers/task_controller.dart';

class EditTaskPage extends StatelessWidget {
  final Task task;

  EditTaskPage({Key? key, required this.task}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task', style: Constants.headerTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedTask = task.copyWith(
                      title: _titleController.text.trim(),
                      description: _descriptionController.text.trim(),
                    );
                    taskController.updateTask(updatedTask);
                    Get.back();
                  }
                },
                child: Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
