import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart'; // Untuk mendapatkan direktori penyimpanan
import 'package:path/path.dart'; // Untuk mengelola path file

class ProfileController extends GetxController {
  var profileImage = Rx<File?>(null);
  var displayName = ''.obs;
  var email = ''.obs;
  var photoURL = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final user = _auth.currentUser;
    if (user != null) {
      displayName.value = user.displayName ?? 'Anonymous';
      email.value = user.email ?? 'Email tidak tersedia';
      photoURL.value = user.photoURL ?? '';
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        // Jika di web, Anda bisa menyimpan gambar di penyimpanan lokal atau menguploadnya ke server lain
      } else {
        // Simpan gambar di penyimpanan lokal
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = basename(pickedFile.path);
        final savedImage =
            await File(pickedFile.path).copy('${appDir.path}/$fileName');

        profileImage.value = savedImage;
        await updateProfileImageInFirestore(savedImage);
      }
    }
  }

  Future<void> updateProfileImageInFirestore(File? image) async {
    if (image != null) {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          // Simpan path lokal ke Firestore
          final profileRef = _firestore.collection('profile').doc(user.uid);
          await profileRef
              .set({'photoURL': image.path}, SetOptions(merge: true));

          // Perbarui URL lokal
          photoURL.value = image.path;

          Get.snackbar('Success', 'Profile picture updated');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to update profile picture');
      }
    }
  }
}
