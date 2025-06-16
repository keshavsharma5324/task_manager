import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:task_manager/domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepo;

  AuthController(this._authRepo);

  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    user.value = _authRepo.getCurrentUser();
    ever(user, (_) => Get.offAllNamed(user.value != null ? '/home' : '/login'));
    super.onInit();
  }

  Future<void> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      user.value = await _authRepo.signUp(email, password);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      user.value = await _authRepo.login(email, password);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authRepo.logout();
    user.value = null;
  }
}