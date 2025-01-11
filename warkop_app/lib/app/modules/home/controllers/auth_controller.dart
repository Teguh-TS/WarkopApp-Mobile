import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  var username = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;

  // Public getter for firestore
  FirebaseFirestore get firestore => _firestore;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  // Register Method
  Future<void> register() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar('Register Error', 'Passwords do not match');
      return;
    }

    try {
      // Buat akun di Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      // Simpan data tambahan ke Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username.value,
        'email': email.value,
        'role': 'admin', // Default role
      });

      // Update displayName di Firebase Authentication
      await userCredential.user!.updateDisplayName(username.value);
      await userCredential.user!.reload();

      Get.snackbar('Register', 'User registered successfully');
      Get.toNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Register Error', e.toString());
    }
  }

  // Login Method
  Future<void> login() async {
    try {
      // Login ke Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      // Ambil UID pengguna yang login
      String uid = userCredential.user!.uid;

      // Periksa role pengguna di Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'];
        print('Role fetched from Firestore: $role'); // Debugging log

        if (role == 'user') {
          Get.snackbar('Login', 'Login successful as User');
          Get.toNamed(Routes.HOME);
        } else if (role == 'admin') {
          Get.snackbar('Login', 'Login successful as Admin');
          print('Navigating to AdminView');
          Get.toNamed(Routes.ADMIN);
        } else {
          Get.snackbar('Login Error', 'Unknown role');
        }
      } else {
        Get.snackbar('Login Error', 'User data not found');
      }
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
