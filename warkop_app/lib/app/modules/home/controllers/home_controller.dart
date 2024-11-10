import 'package:get/get.dart';

class HomeController extends GetxController {
  // Nama pengguna dan index navbar terpilih
  var userName = 'Teguh Tri Saputra'.obs;
  var selectedIndex = 0.obs;

  // Fungsi untuk navigasi berdasarkan index navbar
  void onItemTapped(int index) {
    selectedIndex.value = index;

    // Logika navigasi berdasarkan index navbar
    switch (index) {
      case 0:
        Get.offNamed('/home'); // Navigasi ke HomeView
        break;
      case 1:
        Get.offNamed(
            '/menu'); // Navigasi ke MenuView (ganti jika ada view lain)
        break;
      case 2:
        Get.offNamed(
            '/order'); // Navigasi ke OrderView (ganti jika ada view lain)
        break;
      case 3:
        Get.offNamed('/about'); // Navigasi ke AboutView
        break;
      case 4:
        Get.offNamed(
            '/profile'); // Navigasi ke ProfileView (ganti jika ada view lain)
        break;
      default:
        Get.offNamed('/home');
    }
  }

  @override
  void onInit() {
    super.onInit();
    print("HomeController onInit. Controller instance: ${this.hashCode}");
  }

  @override
  void onReady() {
    print('HomeController onReady');
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
