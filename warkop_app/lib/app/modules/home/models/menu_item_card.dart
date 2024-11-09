import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;

  MenuItemCard(
      {required this.title, required this.price, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Image.asset(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(price),
            ],
          ),
        ],
      ),
    );
  }
}
