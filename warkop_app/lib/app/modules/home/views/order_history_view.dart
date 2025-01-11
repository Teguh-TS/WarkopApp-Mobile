import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orders');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ordersCollection
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Terjadi kesalahan!'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  final orders = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final namaPemesan = order['nama_pemesan'];
                      final totalHarga = order['total_harga'];

                      return ListTile(
                        title: Text('Pemesan: $namaPemesan'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total: Rp $totalHarga'),
                            const SizedBox(height: 8),
                            const Text('Menu:'),
                            ...List<Widget>.from(
                              (order['menus'] as List).map((menu) => Text(
                                    '- ${menu['nama']} x${menu['quantity']}',
                                    style: const TextStyle(fontSize: 14),
                                  )),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ordersCollection.doc(order.id).delete();
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                      child: Text('Belum ada riwayat pesanan.'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown, // Warna coklat
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Navigasi kembali ke HomeView
              },
              child: const Text('Kembali ke Beranda'),
            ),
          ),
        ],
      ),
    );
  }
}
