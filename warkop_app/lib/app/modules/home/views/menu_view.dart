import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../widgets/custom_bottom_navbar.dart';
import 'order_view.dart';

class MenuView extends StatelessWidget {
  final List<Map<String, dynamic>> selectedMenus;

  const MenuView({Key? key, required this.selectedMenus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionReference menusCollection =
        FirebaseFirestore.instance.collection('menus');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Menu'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditDialog(context, menusCollection),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: menusCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final List<QueryDocumentSnapshot> menus = snapshot.data!.docs;

            return ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];
                final nama =
                    menu['nama'] ?? 'Tanpa Nama'; // Default value for 'nama'
                final harga = menu['harga'] ?? 0; // Default value for 'harga'

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(nama),
                    subtitle: Text('Rp $harga'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteMenu(context, menusCollection, menu),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            // Menambahkan menu yang dipilih ke dalam selectedMenus
                            final selectedMenu = {
                              'menu': {
                                'id': menu.id,
                                'nama': menu['nama'],
                                'harga': menu['harga'],
                              },
                              'quantity': 1,
                            };

                            // Mengirim data menu yang dipilih ke OrderView
                            Get.to(() => OrderView(
                                  selectedMenus: [
                                    ...selectedMenus,
                                    selectedMenu
                                  ], // Menambahkan menu ke selectedMenus
                                ));
                          },
                        ),
                      ],
                    ),
                    onTap: () =>
                        _showAddEditDialog(context, menusCollection, menu),
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

  void _showAddEditDialog(
    BuildContext context,
    CollectionReference menusCollection, [
    QueryDocumentSnapshot? menu,
  ]) {
    final TextEditingController nameController =
        TextEditingController(text: menu?['nama'] ?? '');
    final TextEditingController priceController =
        TextEditingController(text: menu?['harga']?.toString() ?? '');
    final TextEditingController tableNumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(menu == null ? 'Tambah Menu' : 'Edit Menu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: tableNumberController,
                decoration: const InputDecoration(labelText: 'No. Meja'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final String nama = nameController.text;
                final int harga = int.tryParse(priceController.text) ?? 0;
                final String tableNumber = tableNumberController.text;

                if (menu == null) {
                  // Tambah data baru
                  menusCollection.add({
                    'nama': nama,
                    'harga': harga,
                    'no_meja': tableNumber,
                  });
                } else {
                  // Update data
                  menusCollection.doc(menu.id).update({
                    'nama': nama,
                    'harga': harga,
                    'no_meja': tableNumber,
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMenu(BuildContext context, CollectionReference menusCollection,
      QueryDocumentSnapshot menu) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Menu'),
          content: const Text('Apakah Anda yakin ingin menghapus menu ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                menusCollection.doc(menu.id).delete();
                Navigator.pop(context);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
