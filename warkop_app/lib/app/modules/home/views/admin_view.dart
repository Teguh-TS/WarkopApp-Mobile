import 'package:flutter/material.dart';
import 'package:warkop_app/app/modules/home/views/admin_about_view.dart';
import 'package:warkop_app/app/modules/home/views/admin_home_view.dart';
import 'package:warkop_app/app/modules/home/views/admin_menu_view.dart';
import 'package:warkop_app/app/modules/home/views/admin_order_view.dart';
import 'package:warkop_app/app/modules/home/views/admin_profile_view.dart';
import 'dashboard_view.dart'; // Halaman Dashboard baru

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    DashboardView(), // Dashboard ditambahkan sebagai halaman pertama
    AdminHomeView(),
    AdminMenuView(
      selectedMenus: [],
    ),
    AdminOrderView(
      selectedMenus: [],
    ),
    AdminAboutView(),
    AdminProfileView()
  ];

  final List<String> pageTitles = [
    'Dashboard', // Dashboard ditambahkan sebagai judul pertama
    'Home',
    'Menu',
    'Order',
    'About',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[selectedIndex]),
        actions: [
          Row(
            children: [
              Text(
                'Admin Username', // Ganti dengan nama pengguna admin
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          // Side Navbar
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
                print("Selected index: $selectedIndex");
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.menu),
                label: Text('Menu'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart),
                label: Text('Order'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          // Main Content
          Expanded(
            child: pages[selectedIndex],
          ),
        ],
      ),
    );
  }
}
