import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_bottom_navbar.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
        elevation: 0,
        title: Obx(() => Text('User: ${controller.userName.value}')),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
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
                        imageUrl: 'lib/assets/black-tea.png',
                        title: 'Teh Hitam',
                        price: 'Rp. 15.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/ginger-tea.png',
                        title: 'Teh Jahe',
                        price: 'Rp. 20.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/green-tea.png',
                        title: 'Teh Hijau',
                        price: 'Rp. 10.000'),
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
                        price: 'Rp. 10.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/rice-egg.jpg',
                        title: 'Nasi Telur',
                        price: 'Rp. 15.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/fried-rice.jpg',
                        title: 'Nasi Goreng',
                        price: 'Rp. 20.000'),
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
                        price: 'Rp. 12.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/gorengan.png',
                        title: 'Gorengan',
                        price: 'Rp. 5.000'),
                    ProductCard(
                        imageUrl: 'lib/assets/kentang.png',
                        title: 'French Fries',
                        price: 'Rp. 15.000'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(),
    );
  }
}
