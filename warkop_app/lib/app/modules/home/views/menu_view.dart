import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/custom_bottom_navbar.dart';

class MenuView extends StatelessWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mengambil instance koleksi 'menus' dari Firestore
    final CollectionReference menusCollection =
        FirebaseFirestore.instance.collection('menus');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Menu'),
        backgroundColor: Colors.brown,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: menusCollection.snapshots(),
        builder: (context, snapshot) {
          // Jika ada error
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan!'));
          }

          // Jika data sedang di-load
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Jika data tersedia
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // Mendapatkan list document dari snapshot
            final List<QueryDocumentSnapshot> menus = snapshot.data!.docs;

            return ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, index) {
                // Mengambil data field 'nama' dan 'harga'
                final nama = menus[index]['nama'] ?? 'Tanpa Nama';
                final harga = menus[index]['harga'] ?? '0';

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('Harga: Rp $harga'),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Belum ada menu tersedia.'));
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavbar(),
    );
  }
}
