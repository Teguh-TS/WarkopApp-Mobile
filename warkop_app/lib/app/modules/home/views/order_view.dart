import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/home_controller.dart';
import '../widgets/custom_bottom_navbar.dart';

class OrderView extends StatelessWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controller untuk input field
    final namaPemesanController = TextEditingController();
    final namaMenuController = TextEditingController();
    final jumlahController = TextEditingController();

    // Reference ke Firestore
    final CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orders');

    // Mengambil HomeController untuk mendapatkan nama pengguna
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      body: Stack(
        children: [
          // Background bercorak (opsional jika ingin menambahkan desain corak)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: const DecorationImage(
                image: AssetImage("lib/assets/background_pattern.png"),
                fit: BoxFit.cover,
                opacity: 0.05,
              ),
            ),
          ),

          // Ikon profil dan nama pengguna di pojok kiri atas
          Positioned(
            top: 40,
            left: 16,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.brown.shade200,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Obx(() => Text(
                      controller.userName.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
          ),

          // Ikon notifikasi di pojok kanan atas
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.brown),
              onPressed: () {
                // Aksi notifikasi bisa ditambahkan di sini
              },
            ),
          ),

          // Form input untuk membuat pesanan
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Nama Pemesan
                TextField(
                  controller: namaPemesanController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pemesan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Input Nama Menu
                TextField(
                  controller: namaMenuController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Menu',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Input Jumlah Pesanan
                TextField(
                  controller: jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol Submit Pesanan
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    // Mengambil nilai dari controller
                    final String namaPemesan = namaPemesanController.text;
                    final String namaMenu = namaMenuController.text;
                    final int jumlah = int.tryParse(jumlahController.text) ?? 0;

                    if (namaPemesan.isEmpty ||
                        namaMenu.isEmpty ||
                        jumlah <= 0) {
                      Get.snackbar(
                        'Error',
                        'Mohon isi semua field dengan benar',
                        snackPosition:
                            SnackPosition.TOP, // Notifikasi muncul di atas
                      );
                      return;
                    }

                    try {
                      // Mendapatkan harga menu dari Firestore
                      final menuSnapshot = await FirebaseFirestore.instance
                          .collection('menus')
                          .where('nama', isEqualTo: namaMenu)
                          .get();

                      if (menuSnapshot.docs.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Menu tidak ditemukan',
                          snackPosition: SnackPosition.TOP,
                        );
                        return;
                      }

                      final hargaMenu = menuSnapshot.docs.first['harga'] as int;
                      final totalHarga = hargaMenu * jumlah;

                      // Menyimpan data pesanan ke Firestore
                      await ordersCollection.add({
                        'nama_pemesan': namaPemesan,
                        'nama_menu': namaMenu,
                        'jumlah': jumlah,
                        'total_harga': totalHarga,
                        'waktu_pesan': FieldValue.serverTimestamp(),
                      });

                      // Menampilkan notifikasi sukses di atas
                      Get.snackbar(
                        'Sukses',
                        'Pesanan berhasil dibuat!',
                        snackPosition: SnackPosition.TOP,
                      );

                      // Mengosongkan input setelah berhasil
                      namaPemesanController.clear();
                      namaMenuController.clear();
                      jumlahController.clear();
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Gagal membuat pesanan: $e',
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                  },
                  child: const Text('Buat Pesanan'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavbar(),
    );
  }
}
