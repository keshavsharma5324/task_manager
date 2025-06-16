import 'package:get/get.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/domain/usecases/task_usecase.dart';

class TaskController extends GetxController {
  final TaskUseCases useCases;
  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = false.obs;

  TaskController(this.useCases);

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      tasks.value = await useCases.getTasks();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tasks');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask(String title, String description) async {
    try {
      await useCases.addTask(title, description);
      await fetchTasks();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await useCases.updateTask(task);
      await fetchTasks();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await useCases.deleteTask(taskId);
      tasks.removeWhere((task) => task.id == taskId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task');
    }
  }
}