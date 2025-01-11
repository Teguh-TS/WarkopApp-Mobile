import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rxn<User> user = Rxn<User>();
  final RxMap<String, dynamic> userData = RxMap<String, dynamic>({});
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    if (user.value != null) {
      fetchUserData();
    } else {
      isLoading.value = false;
    }
  }

  // Mengambil data pengguna dari Firestore
  void fetchUserData() async {
    try {
      isLoading.value = true;
      final userEmail = user.value?.email;
      if (userEmail == null) {
        Get.snackbar('Error', 'User email is null.');
        return;
      }

      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        userData.value = querySnapshot.docs.first.data();
      } else {
        Get.snackbar('Error', 'User data not found in Firestore.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Logout pengguna
  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/welcome'); // Pastikan ada route ke welcome screen
  }

  // Mengganti password pengguna
  void changePassword() async {
    try {
      if (user.value?.email != null) {
        await _auth.sendPasswordResetEmail(email: user.value!.email!);
        Get.snackbar('Success', 'Password reset email sent.');
      } else {
        Get.snackbar('Error', 'Email not found for the current user.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send password reset email: $e');
    }
  }
}
