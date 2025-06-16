import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/domain/usecases/task_usecase.dart';
import 'package:task_manager/presentation/controllers/task_controller.dart';
import 'task_controller_test.mocks.dart';

@GenerateMocks([TaskUseCases])
void main() {
  late TaskController taskController;
  late MockTaskUseCases mockTaskUseCases;
  final mockTasks = [
    Task(id: '1', title: 'Task 1', description: 'Desc 1', createdAt: DateTime.now(), isCompleted: false, userId: 'user1'),
    Task(id: '2', title: 'Task 2', description: 'Desc 2', createdAt: DateTime.now(), isCompleted: true, userId: 'user1'),
  ];

  setUp(() {
    mockTaskUseCases = MockTaskUseCases();
    taskController = TaskController(mockTaskUseCases);
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  test('Initial state should be empty', () {
    expect(taskController.tasks.isEmpty, true);
    expect(taskController.isLoading.value, false);
  });

  test('Fetch tasks should populate tasks list', () async {
    when(mockTaskUseCases.getTasks()).thenAnswer((_) async => mockTasks);

    await taskController.fetchTasks();

    expect(taskController.tasks.length, 2);
    expect(taskController.tasks[0].title, 'Task 1');
    expect(taskController.isLoading.value, false);
  });

  test('Add task should refresh task list', () async {
    when(mockTaskUseCases.addTask('New Task', 'Description'))
        .thenAnswer((_) async => {});
    when(mockTaskUseCases.getTasks()).thenAnswer((_) async => mockTasks);

    await taskController.addTask('New Task', 'Description');

    verify(mockTaskUseCases.addTask('New Task', 'Description')).called(1);
    expect(taskController.tasks.length, 2);
  });

  test('Update task should refresh task list', () async {
    final updatedTask = mockTasks[0].copyWith(title: 'Updated Task');
    when(mockTaskUseCases.updateTask(updatedTask))
        .thenAnswer((_) async => {});
    when(mockTaskUseCases.getTasks()).thenAnswer((_) async => mockTasks);

    await taskController.updateTask(updatedTask);

    verify(mockTaskUseCases.updateTask(updatedTask)).called(1);
    expect(taskController.tasks.length, 2);
  });

  test('Delete task should remove from list', () async {
    when(mockTaskUseCases.deleteTask('1')).thenAnswer((_) async => {});

    taskController.tasks.value = mockTasks;
    await taskController.deleteTask('1');

    expect(taskController.tasks.length, 1);
    expect(taskController.tasks[0].id, '2');
  });

  /*test('Toggle task completion should update status', () async {
    final task = mockTasks[0];
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);

    when(mockTaskUseCases.toggleTaskCompletion(task))
        .thenAnswer((_) async => {});

    taskController.tasks.value = [task];
    await taskController.toggleTaskCompletion(task);

    expect(taskController.tasks[0].isCompleted, true);
  });*/
}