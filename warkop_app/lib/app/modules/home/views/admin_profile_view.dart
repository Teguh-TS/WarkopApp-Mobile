import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import '../controllers/profile_controller.dart';

class AdminProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              GestureDetector(
                onTap: controller.pickImage,
                child: Obx(() {
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.photoURL.isNotEmpty
                        ? NetworkImage(controller.photoURL.value)
                        : kIsWeb
                            ? AssetImage('lib/assets/profile.png')
                                as ImageProvider
                            : controller.profileImage.value != null
                                ? FileImage(controller.profileImage.value!)
                                : AssetImage('lib/assets/profile.png'),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.edit, size: 20, color: Colors.brown),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),

              // User Info
              Obx(() {
                return Column(
                  children: [
                    Text(
                      controller.displayName.value,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      controller.email.value,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                );
              }),

              SizedBox(height: 24),

              // Settings
              ListTile(
                leading: Icon(Icons.settings, color: Colors.brown),
                title: Text('Pengaturan', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Get.toNamed('/setting');
                },
              ),

              // Promo
              ListTile(
                leading: Icon(Icons.local_offer, color: Colors.brown),
                title: Text('Event Promo', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Get.toNamed('/event');
                },
              ),

              // Ulasan
              ListTile(
                leading: Icon(Icons.rate_review, color: Colors.brown),
                title: Text('Ulasan', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Get.toNamed('/review');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
