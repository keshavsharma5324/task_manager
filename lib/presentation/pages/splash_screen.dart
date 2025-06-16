import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controllers/auth_controller.dart';
import 'package:task_manager/presentation/controllers/task_controller.dart';

class SplashScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          if (authController.user.value != null) {
            Future.delayed(Duration.zero, () => Get.offNamed('/home'));
          } else {
            Future.delayed(Duration.zero, () => Get.offNamed('/login'));
          }
          return CircularProgressIndicator();
        }),
      ),
    );
  }
}
