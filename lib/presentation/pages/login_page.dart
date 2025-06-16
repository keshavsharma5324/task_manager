import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/utils/constants.dart';
import 'package:task_manager/presentation/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController authController = Get.find();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login', style: Constants.headerTextStyle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!GetUtils.isEmail(value)) return 'Invalid email';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) return 'Password too short';
                  return null;
                },
              ),
              SizedBox(height: 30),
              Obx(
                () =>
                    authController.isLoading.value
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              authController.login(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                            }
                          },
                          child: Text('Login'),
                        ),
              ),
              TextButton(
                onPressed: () => Get.toNamed('/signup'),
                child: Text('Create Account'),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text('Task Manager', style: Constants.headerTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
