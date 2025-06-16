import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/utils/constants.dart';
import 'package:task_manager/presentation/controllers/auth_controller.dart';
import 'package:task_manager/presentation/controllers/task_controller.dart';
import 'package:task_manager/presentation/widgets/task_item.dart';

class HomePage extends GetView<TaskController> {
  HomePage({super.key}) {
    controller.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks', style: Constants.headerTextStyle),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.deepPurple,),
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Get.toNamed('/add-task'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder:
              (context, index) => TaskItem(
                task: controller.tasks[index],
                onEdit:
                    () => Get.toNamed(
                      '/edit-task',
                      arguments: controller.tasks[index],
                    ),
                onDelete:
                    () => controller.deleteTask(controller.tasks[index].id),
              ),
        );
      }),
    );
  }
}
