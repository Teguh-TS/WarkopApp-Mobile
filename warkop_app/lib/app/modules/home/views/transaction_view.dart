import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionView extends StatefulWidget {
  final String orderId; // ID pesanan yang dikirim dari OrderView
  final String displayName;
  final String noMeja;
  final List<Map<String, dynamic>> selectedMenus;
  final int totalHarga;
  final String catatan;

  const TransactionView({
    Key? key,
    required this.orderId, // Tambahkan parameter lain sesuai kebutuhan
    required this.displayName,
    required this.noMeja,
    required this.selectedMenus,
    required this.totalHarga,
    required this.catatan,
  }) : super(key: key);

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  String selectedPaymentMethod = ''; // Menyimpan metode pembayaran yang dipilih

  Future<void> _submitTransaction() async {
    if (selectedPaymentMethod.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih metode pembayaran terlebih dahulu!',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      final transactionsCollection =
          FirebaseFirestore.instance.collection('transactions');
      final ordersCollection = FirebaseFirestore.instance.collection('orders');

      // Simpan data transaksi ke Firestore
      await transactionsCollection.add({
        'order_id': widget.orderId,
        'payment_method': selectedPaymentMethod,
        'transaction_date': FieldValue.serverTimestamp(),
      });

      // Perbarui status pesanan di Firestore
      await ordersCollection.doc(widget.orderId).update({
        'status': 'completed',
      });

      Get.snackbar(
        'Sukses',
        'Transaksi berhasil disimpan!',
        snackPosition: SnackPosition.TOP,
      );

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan transaksi: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metode Pembayaran'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            RadioListTile(
              title: const Text('QRIS'),
              value: 'QRIS',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text('Debit'),
              value: 'Debit',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text('Cash'),
              value: 'Cash',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value.toString();
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTransaction,
              child: const Text('Konfirmasi Pembayaran'),
            ),
          ],
        ),
      ),
    );
  }
}
