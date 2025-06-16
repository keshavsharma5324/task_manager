import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/network/firebase_service.dart';
import 'package:task_manager/data/repositories/auth_repository_impl.dart';
import 'package:task_manager/data/repositories/task_repository_impl.dart';
import 'package:task_manager/domain/repositories/auth_repository.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';
import 'package:task_manager/domain/usecases/task_usecase.dart';
import 'package:task_manager/presentation/controllers/auth_controller.dart';
import 'package:task_manager/presentation/controllers/task_controller.dart';
import 'package:task_manager/presentation/pages/add_task_page.dart';
import 'package:task_manager/presentation/pages/edit_task_page.dart';
import 'package:task_manager/presentation/pages/home_page.dart';
import 'package:task_manager/presentation/pages/login_page.dart';
import 'package:task_manager/presentation/pages/signup_page.dart';
import 'package:task_manager/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Manager',
      initialBinding: AppBindings(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignupPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/add-task', page: () => AddTaskPage()),
        GetPage(name: '/edit-task', page: () => EditTaskPage(task: Get.arguments)),
      ],
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
    Get.put<AuthController>(AuthController(Get.find()), permanent: true);
    Get.lazyPut<TaskRepository>(() => TaskRepositoryImpl());
    Get.lazyPut<TaskUseCases>(() => TaskUseCases(Get.find()));
    Get.put<TaskController>(TaskController(Get.find()));
  }
}