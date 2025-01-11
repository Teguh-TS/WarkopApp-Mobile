import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/custom_bottom_navbar.dart';
import 'menu_view.dart';
import 'order_history_view.dart';
import 'transaction_view.dart'; // Import TransactionView

class OrderView extends StatefulWidget {
  final List<Map<String, dynamic>> selectedMenus;
  const OrderView({Key? key, required this.selectedMenus}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final TextEditingController noMejaController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  String? _displayName;

  @override
  void initState() {
    super.initState();
    _fetchDisplayName();
  }

  Future<void> _fetchDisplayName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _displayName = userDoc.data()?['username'] ?? 'Unknown';
      });
    }
  }

  int _calculateTotalPrice() {
    int total = 0;
    for (var menu in widget.selectedMenus) {
      total += (menu['menu']['harga'] as int) * (menu['quantity'] as int);
    }
    return total;
  }

  Future<void> _navigateToTransaction(BuildContext context) async {
    final String noMeja = noMejaController.text.trim();
    final String catatan = catatanController.text.trim();

    if (_displayName == null ||
        noMeja.isEmpty ||
        widget.selectedMenus.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon isi semua data yang diperlukan',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    Get.to(() => TransactionView(
          displayName: _displayName!,
          noMeja: noMeja,
          selectedMenus: widget.selectedMenus,
          totalHarga: _calculateTotalPrice(),
          catatan: catatan,
          orderId: '',
        ));
  }

  Future<void> _saveOrderToFirestore() async {
    final String noMeja = noMejaController.text.trim();
    final String catatan = catatanController.text.trim();
    final int totalHarga = _calculateTotalPrice();

    if (_displayName == null ||
        noMeja.isEmpty ||
        widget.selectedMenus.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon isi semua data yang diperlukan',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final ordersCollection = FirebaseFirestore.instance.collection('orders');

      // Simpan data pesanan ke Firestore
      final orderData = {
        'userId': userId,
        'nama_pemesan': _displayName,
        'no_meja': noMeja,
        'catatan': catatan,
        'total_harga': totalHarga,
        'menus': widget.selectedMenus.map((menu) {
          return {
            'nama': menu['menu']['nama'],
            'harga': menu['menu']['harga'],
            'quantity': menu['quantity'],
          };
        }).toList(),
        'status': 'pending', // Status awal pesanan
        'created_at': FieldValue.serverTimestamp(),
      };

      final orderRef = await ordersCollection.add(orderData);

      // Navigasi ke TransactionView dengan ID pesanan
      Get.to(() => TransactionView(
            orderId: orderRef.id,
            displayName: _displayName!,
            noMeja: noMeja,
            selectedMenus: widget.selectedMenus,
            totalHarga: totalHarga,
            catatan: catatan,
          ));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan pesanan: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Pesanan'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Pemesan: ${_displayName ?? 'Loading...'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noMejaController,
              decoration: const InputDecoration(
                labelText: 'No. Meja',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedMenus.length,
                itemBuilder: (context, index) {
                  final menu = widget.selectedMenus[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(menu['menu']['nama']),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: menu['quantity'].toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Jumlah',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                menu['quantity'] = int.tryParse(value) ?? 1;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.selectedMenus.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: catatanController,
              decoration: const InputDecoration(
                labelText: 'Catatan Tambahan (Opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total Harga: Rp ${_calculateTotalPrice()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => MenuView(
                          selectedMenus: widget.selectedMenus,
                        ));
                  },
                  child: const Text('Tambah Menu'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _saveOrderToFirestore(),
                  child: const Text('Buat Pesanan'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Get.to(() => const OrderHistoryView());
                },
                child: const Text('Cek History'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(),
    );
  }
}
