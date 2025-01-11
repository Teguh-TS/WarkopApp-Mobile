import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderController extends GetxController {
  final TextEditingController namaPemesanController = TextEditingController();
  final TextEditingController namaMenuController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  final RxString userName = 'User'.obs;
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  void addOrder(String namaPemesan, String namaMenu, int jumlah) {
    if (namaPemesan.trim().isEmpty || namaMenu.trim().isEmpty || jumlah <= 0) {
      Get.snackbar('Error', 'Mohon isi semua field dengan benar');
      return;
    }

    final order = {
      'nama_pemesan': namaPemesan,
      'nama_menu': namaMenu,
      'jumlah': jumlah,
    };

    orders.add(order);
    submitOrder(namaPemesan, namaMenu, jumlah);
  }

  void submitOrder(String namaPemesan, String namaMenu, int jumlah) async {
    Get.dialog(Center(child: CircularProgressIndicator()),
        barrierDismissible: false);

    try {
      final menuSnapshot = await FirebaseFirestore.instance
          .collection('menus')
          .where('nama', isEqualTo: namaMenu)
          .get();

      if (menuSnapshot.docs.isEmpty) {
        Get.back();
        Get.snackbar('Error', 'Menu tidak ditemukan');
        return;
      }

      final hargaMenu =
          int.tryParse(menuSnapshot.docs.first['harga'].toString()) ?? 0;
      final totalHarga = hargaMenu * jumlah;

      await ordersCollection.add({
        'nama_pemesan': namaPemesan,
        'nama_menu': namaMenu,
        'jumlah': jumlah,
        'total_harga': totalHarga,
        'waktu_pesan': FieldValue.serverTimestamp(),
      });

      Get.back();
      Get.snackbar('Sukses', 'Pesanan berhasil dibuat!');
    } catch (e) {
      Get.back();
      print('Error submitOrder: $e');
      Get.snackbar('Error', 'Gagal membuat pesanan: ${e.toString()}');
    }
  }
}
