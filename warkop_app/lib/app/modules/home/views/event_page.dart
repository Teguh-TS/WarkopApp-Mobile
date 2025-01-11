import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _imagePath;
  String? _uploadMessage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _uploadMessage = "Gambar berhasil diunggah!";
      });
    }
  }

  Future<void> _addOrEditPromo({String? id}) async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _imagePath != null) {
      final promoData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'imagePath': _imagePath,
      };

      if (id == null) {
        await _firestore.collection('event').add(promoData);
      } else {
        await _firestore.collection('event').doc(id).update(promoData);
      }

      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _imagePath = null;
        _uploadMessage = null;
      });
      Navigator.pop(context);
    }
  }

  void _showPromoDialog({String? id, Map<String, dynamic>? promo}) {
    if (promo != null) {
      _titleController.text = promo['title'];
      _descriptionController.text = promo['description'];
      _imagePath = promo['imagePath'];
    } else {
      _titleController.clear();
      _descriptionController.clear();
      _imagePath = null;
      _uploadMessage = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Tambah Promo' : 'Edit Promo'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Judul Promo'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Deskripsi Promo'),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pilih Gambar'),
                ),
                if (_uploadMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _uploadMessage!,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
                if (_imagePath != null) ...[
                  const SizedBox(height: 8),
                  kIsWeb
                      ? Image.network(
                          _imagePath!,
                          width: 100,
                          height: 50,
                          fit: BoxFit.contain,
                        )
                      : Image.file(
                          File(_imagePath!),
                          width: 100,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () => _addOrEditPromo(id: id),
              child: Text(id == null ? 'Tambah' : 'Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Promo'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('event').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Belum ada promo.'));
          }

          final promos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: promos.length,
            itemBuilder: (context, index) {
              final promo = promos[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kIsWeb
                          ? Image.network(
                              promo['imagePath'],
                              width: 200,
                              height: 100,
                              fit: BoxFit.contain,
                            )
                          : Image.file(
                              File(promo['imagePath']),
                              width: 200,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                      const SizedBox(height: 8),
                      Text(
                        promo['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        promo['description'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showPromoDialog(
                              id: promo.id,
                              promo: promo.data() as Map<String, dynamic>,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await _firestore
                                  .collection('event')
                                  .doc(promo.id)
                                  .delete();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPromoDialog(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.brown,
      ),
    );
  }
}
