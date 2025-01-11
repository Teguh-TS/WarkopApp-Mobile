import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Nama pengguna dan index navbar terpilih
  var userName = ''.obs;
  var selectedIndex = 0.obs;

  // Daftar data dan hasil pencarian
  var homes = <Map<String, dynamic>>[].obs;
  var filteredHomes = <Map<String, dynamic>>[].obs;
  var selectedMenus = <Map<String, dynamic>>[].obs;
  var events = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // Fungsi untuk mengambil event (promo)
  Future<void> fetchEvents() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('events').get();
      events.value = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch events: $e');
    }
  }

  // Fungsi untuk menambahkan data baru (CREATE)
  Future<void> addProduct(Map<String, dynamic> newProduct) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('displays')
          .add(newProduct);
      homes.add({'id': docRef.id, ...newProduct});
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    }
  }

  // Fungsi untuk membaca data dari Firestore (READ)
  Future<void> fetchHomes() async {
    try {
      isLoading.value = true;
      final snapshot =
          await FirebaseFirestore.instance.collection('homes').get();
      homes.value = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
      filteredHomes.value = homes; // Inisialisasi data pencarian
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch homes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk memperbarui data (UPDATE)
  Future<void> updateProduct(
      String productId, Map<String, dynamic> updatedProduct) async {
    try {
      await FirebaseFirestore.instance
          .collection('displays')
          .doc(productId)
          .update(updatedProduct);
      int index = homes.indexWhere((home) => home['id'] == productId);
      if (index != -1) {
        homes[index] = {'id': productId, ...updatedProduct};
      }
      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }

  // Fungsi untuk menghapus data (DELETE)
  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('displays')
          .doc(productId)
          .delete();
      homes.removeWhere((home) => home['id'] == productId);
      Get.snackbar('Success', 'Product deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  // Fungsi untuk mengambil nama pengguna dari Firebase Auth
  void fetchUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? 'Guest';
    } else {
      userName.value = 'Guest';
    }
  }

  // Fungsi untuk filter kategori
  void filterCategory(String category) {
    filteredHomes.value = homes
        .where(
            (home) => home['category']?.toLowerCase() == category.toLowerCase())
        .toList();
    Get.snackbar('Filter Applied', 'Filtered by category: $category');
  }

  // Fungsi untuk mencari produk berdasarkan query
  void searchProducts(String query) {
    filteredHomes.value = homes
        .where(
            (home) => home['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void showProductOptions(String productId) {
    // Logic for showing product options (e.g., opening a dialog, navigating to another screen, etc.)
    print('Show options for product with ID: $productId');
    // You can replace this with your actual logic for showing product options.
  }

  // Fungsi untuk logout
  void logout() {
    FirebaseAuth.instance.signOut();
    Get.offNamed('/welcome');
  }

  // Fungsi untuk navigasi berdasarkan index navbar
  void onItemTapped(int index) {
    selectedIndex.value = index;

    // Logika navigasi berdasarkan index navbar
    switch (index) {
      case 0:
        Get.toNamed('/home'); // Navigasi ke HomeView
        break;
      case 1:
        Get.toNamed('/menu'); // Navigasi ke MenuView
        break;
      case 2:
        Get.toNamed('/order'); // Navigasi ke OrderView
        break;
      case 3:
        Get.toNamed('/about'); // Navigasi ke AboutView
        break;
      case 4:
        Get.toNamed('/profile'); // Navigasi ke ProfileView
        break;
      default:
        Get.toNamed('/home');
    }
  }

  // Getter untuk data produk berdasarkan kategori
  List<Map<String, dynamic>> getProductsByCategory(String category) {
    return homes
        .where(
            (home) => home['category']?.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Getter untuk daftar produk
  List<Map<String, dynamic>> get products => homes;

  // Fungsi untuk mengedit produk
  void editProduct(String productId, Map<String, dynamic> updatedProduct) {
    updateProduct(productId, updatedProduct);
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
    fetchHomes();
    fetchEvents(); // Menambahkan fungsi untuk mengambil promo
  }
}
