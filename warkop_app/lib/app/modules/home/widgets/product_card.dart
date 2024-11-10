import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const ProductCard(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.brown.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(title, style: const TextStyle(color: Colors.white)),
                Text(price, style: const TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  child: const Text('Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
