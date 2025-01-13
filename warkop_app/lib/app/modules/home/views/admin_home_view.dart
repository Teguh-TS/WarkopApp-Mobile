import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/product_card.dart';

class AdminHomeView extends StatefulWidget {
  @override
  State<AdminHomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<AdminHomeView> {
  final HomeController controller = Get.find<HomeController>();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("HomeView build method called");
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Text('Selamat Datang, ${controller.userName.value}')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: const Icon(Icons.account_circle),
              color: Colors.white,
              onPressed: () {
                _showProfileMenu(context);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // Buttons for "Cek Promo" and "Booking Sekarang"
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/event'); // Navigate to EventPage
                      },
                      child: Text("Cek Promo"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Set button color
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/booking'); // Navigate to BookingView
                      },
                      child: Text("Booking Sekarang"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Set button color
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Banner Carousel
              Container(
                height: 150,
                margin: const EdgeInsets.all(10),
                child: PageView(
                  children: [
                    Image.asset('lib/assets/coffee.png', fit: BoxFit.cover),
                    Image.asset('lib/assets/cafe.png', fit: BoxFit.cover),
                  ],
                ),
              ),
              // Section Minuman
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Minuman',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProductCard(
                        imageUrl: 'lib/assets/kopi-hitam.png',
                        title: 'Kopi Hitam',
                        price: 'Rp. 7.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/espresso.png',
                        title: 'Espresso',
                        price: 'Rp. 20.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/stmj.jpg',
                        title: 'STMJ',
                        price: 'Rp. 12.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/black-tea.png',
                        title: 'Teh Hitam',
                        price: 'Rp. 5.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/ginger-tea.png',
                        title: 'Teh Jahe',
                        price: 'Rp. 6.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/green-tea.png',
                        title: 'Teh Hijau',
                        price: 'Rp. 6.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/coklat.png',
                        title: 'Ice Cocholate',
                        price: 'Rp. 16.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/matcha.png',
                        title: 'Ice Matcha',
                        price: 'Rp. 16.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/taro.jpg',
                        title: 'Ice Taro',
                        price: 'Rp. 17.000'),
                  ],
                ),
              ),
              // Section Makanan
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Makanan',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProductCard(
                        imageUrl: 'lib/assets/indomie.png',
                        title: 'Indomie',
                        price: 'Rp. 9.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/rice-egg.jpg',
                        title: 'Nasi Telur',
                        price: 'Rp. 10.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/fried-rice.jpg',
                        title: 'Nasi Goreng',
                        price: 'Rp. 15.000'),
                  ],
                ),
              ),
              // Section Cemilan
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Camilan',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProductCard(
                        imageUrl: 'lib/assets/toast.png',
                        title: 'Roti Bakar',
                        price: 'Rp. 10.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/gorengan.png',
                        title: 'Gorengan',
                        price: 'Rp. 6.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/kentang.png',
                        title: 'Kentang Goreng',
                        price: 'Rp. 11.000'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final position =
        button.localToGlobal(Offset.zero); // Position of the button

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy + 50, position.dx - 100, position.dy + 200),
      items: [
        PopupMenuItem(
          child: Column(
            children: [
              // Menampilkan informasi profil di dalam kotak persegi
              Obx(() => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.person, size: 50, color: Colors.black),
                        SizedBox(height: 10),
                        Text(
                          controller.userName.value,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/setting'); // Navigasi ke SettingView
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              controller.logout();
              Navigator.pop(context);
              Get.offNamed('/welcome'); // Navigasi ke WelcomeView
            },
          ),
        ),
      ],
    );
  }
}
