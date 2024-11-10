import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/custom_bottom_navbar.dart';

class AboutView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background bercorak
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: const DecorationImage(
                image: AssetImage(
                    "lib/assets/background_pattern.png"), // Ganti dengan corak yang tersedia di assets
                fit: BoxFit.cover,
                opacity: 0.1, // Mengatur tingkat transparansi corak
              ),
            ),
          ),

          // Ikon profil dan nama pengguna
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
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),

          // Ikon notifikasi
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.brown),
              onPressed: () {
                // Tambahkan aksi notifikasi jika diperlukan
              },
            ),
          ),

          // Konten utama AboutView
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gambar logo aplikasi
                Image.asset(
                  'lib/assets/logo2.png', // Ganti dengan logo yang Anda miliki di folder assets
                  height: 100,
                ),
                const SizedBox(height: 16),

                // Deskripsi aplikasi
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Drinks adalah platform warung sapi yang hadir untuk menikmati berbagai menu, memudahkan anda menemukan berbagai pilihan menu dari Warung Kopi di Surabaya. Kami hadir untuk memudahkan para pecinta kopi dan menu makananya menikmati cita rasa khas warung kopi lokal. Dengan berbagai pilihan kopi, teh, minuman dingin, serta camilan lezat. Drinks menawarkan pengalaman ngopi yang praktis dan autentik langsung dari Surabaya.\n'
                    'Melalui aplikasi ini Anda dapat dengan mudah memesan berbagai manu yang tersedia di warung kopi kami langsung dari parangkat Anda. Kami berkomitmen untuk memberikan kenyamanan dalam pemesanan online, sehingga memudahkan pelanggan dalam menikmati minuman favorit mereka. Drinks hadir untuk memenuhi kebutuhan Anda akan pengalaman ngopi berkualitas yang autentik dan praktis di Surabaya\n'
                    'Drinks juga menawarkan berbagai pilihan menu yang dibuat dengan bahan berkualitas, disajikan dengan penuh kehangatan khas Surabaya. Mulai dan topi yang nikmat, teh yang menyegarkan hingga camikon lezat untuk menamani waktu bersantai Anda semus tersedia di sini. Kami berharap setiap kunjungan Drinks menjadi momen menyenangkan dan mengesankan bagi Anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
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
