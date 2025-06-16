import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/domain/repositories/auth_repository.dart';
import 'package:task_manager/presentation/controllers/auth_controller.dart';

import 'auth_controller_test.mocks.dart';

@GenerateMocks([AuthRepository, User])
void main() {
  late AuthController authController;
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    authController = AuthController(mockAuthRepository);
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  test('Initial state should have null user', () {
    expect(authController.user.value, isNull);
  });

  test('Sign up should set user on success', () async {
    when(mockAuthRepository.signUp('test@example.com', 'password123'))
        .thenAnswer((_) async => mockUser);

    await authController.signUp('test@example.com', 'password123');

    expect(authController.user.value, mockUser);
    expect(authController.isLoading.value, false);
  });

  test('Sign up should show error on failure', () async {
    when(mockAuthRepository.signUp('test@example.com', 'password123'))
        .thenThrow(Exception('Signup failed'));

    await authController.signUp('test@example.com', 'password123');

    expect(authController.user.value, isNull);
    expect(authController.isLoading.value, false);
  }, skip: true);

  test('Login should set user on success', () async {
    when(mockAuthRepository.login('test@example.com', 'password123'))
        .thenAnswer((_) async => mockUser);

    await authController.login('test@example.com', 'password123');

    expect(authController.user.value, mockUser);
    expect(authController.isLoading.value, false);
  });

  test('Logout should clear user', () async {
    authController.user.value = mockUser;
    when(mockAuthRepository.logout()).thenAnswer((_) async => {});

    await authController.logout();

    expect(authController.user.value, isNull);
  });

  test('Auth state changes should update user', () {
    final userStream = Stream<User?>.fromIterable([null, mockUser, null]);
    when(mockAuthRepository.authStateChanges()).thenAnswer((_) => userStream);
    when(mockAuthRepository.getCurrentUser()).thenAnswer((_) => null);

    authController.onInit();

    expect(authController.user.value, isNull);

    // Wait for stream to emit values
    Future.delayed(Duration.zero, () {
      expect(authController.user.value, mockUser);
    });

    Future.delayed(Duration(milliseconds: 10), () {
      expect(authController.user.value, isNull);
    });
  });
}