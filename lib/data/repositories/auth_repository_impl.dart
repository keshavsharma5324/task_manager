import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/core/network/firebase_service.dart';
import 'package:task_manager/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  var firebaseAuth = FirebaseService.auth;

  @override
  Future<User?> login(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  @override
  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Signup failed');
    }
  }

  @override
  Future<void> logout() async => await firebaseAuth.signOut();

  @override
  User? getCurrentUser() => firebaseAuth.currentUser;

  @override
  Stream<User?> authStateChanges() => firebaseAuth.authStateChanges();
}