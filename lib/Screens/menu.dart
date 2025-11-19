import 'package:flutter/material.dart';
import 'package:football_shop/widgets/right_drawer.dart';
import 'package:football_shop/widgets/product_card.dart';

/// Halaman utama Football Shop
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // Data tombol menu
  final List<ItemHomepage> items = const [
    ItemHomepage("All Products", Icons.list, Colors.blue),
    ItemHomepage("My Products", Icons.shopping_bag, Colors.green),
    ItemHomepage("Create Product", Icons.add, Colors.red),
    ItemHomepage("Logout", Icons.logout,Colors.yellow),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Football Shop',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      endDrawer: RightDrawer(),
      body:  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: GridView.count(
          padding: const EdgeInsets.all(30),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          crossAxisCount: 2,
          shrinkWrap: true,
          children: items.map((ItemHomepage item) {
            return ItemCard(item);
          }).toList(),
        ),
      ),
    ),
    );
  }
}

/// Model data untuk tombol menu
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  const ItemHomepage(this.name, this.icon, this.color);
}

/// Widget kartu tombol
