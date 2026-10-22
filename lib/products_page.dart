import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'product_widgets.dart';
// import 'details_page.dart'; // used by the Navigator version below

class ProductsPage extends StatefulWidget {
  final String username;

  const ProductsPage({super.key, required this.username});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int favorites = 0;
  double screenWidth = 0;
  String cartMessage = "";

  final List<Map<String, dynamic>> products = [
    {"name": "Laptop", "price": 1200},
    {"name": "Phone", "price": 800},
    {"name": "Headphones", "price": 150},
    {"name": "Keyboard", "price": 90},
    {"name": "Mouse", "price": 40},
    {"name": "Monitor", "price": 300},
    {"name": "Smart Watch", "price": 250},
    {"name": "Tablet", "price": 600},
  ];

  @override
  void initState() {
    super.initState();
    print("ProductsPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    screenWidth = size.width;
    print("ProductsPage: didChangeDependencies -> width: ${size.width}, height: ${size.height}");
  }

  @override
  void deactivate() {
    print("ProductsPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("ProductsPage: dispose");
    super.dispose();
  }

  void _addFavorite() {
    setState(() {
      favorites++;
    });
  }

  Future<void> _openDetails(int index) async {
    final String name = products[index]["name"];
    final int price = products[index]["price"];

    // ---------- Part 2: Navigator version (commented out) ----------
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => DetailsPage(name: name, price: price)),
    // );

    // ---------- Part 3: go_router version ----------
    // push keeps Products in the stack so we can come back and receive a result.
    final result = await context.push<String>('/details/$name/$price');

    if (result != null) {
      setState(() {
        cartMessage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ProductsPage: build");
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, ${widget.username}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Favorites: $favorites", style: const TextStyle(fontSize: 16)),
            Text("Screen width: ${screenWidth.toStringAsFixed(0)}"),
            if (cartMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(cartMessage, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: screenWidth < 600
                  ? ProductsListView(
                      products: products,
                      onFavoritePressed: _addFavorite,
                      onProductTap: _openDetails,
                    )
                  : ProductsGridView(
                      products: products,
                      onFavoritePressed: _addFavorite,
                      onProductTap: _openDetails,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
