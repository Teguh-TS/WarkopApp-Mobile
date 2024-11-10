import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  var email = ''.obs;
  var password = ''.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  // Register Method
  Future<void> register() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      Get.snackbar('Register', 'User registered successfully');
      Get.toNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Register Error', e.toString());
    }
  }

  // Login Method
  Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      Get.snackbar('Login', 'Login successful');
      Get.toNamed(Routes.HOME); // Menghapus semua halaman sebelumnya
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
    }
  }

  // Logout Method
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.WELCOME);
  }
}
