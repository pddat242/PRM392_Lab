import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'screens/storage_screen.dart';
import 'screens/crud_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CrudScreen(),
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<dynamic> products = [];
  Future<void> loadProducts() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/products.json',
    );
    final data = jsonDecode(jsonString);
    setState(() {
      products = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.1 - Products'),
        backgroundColor: Colors.blue,
      ),

      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: Text(product['name']),
              subtitle: Text(
                'Price: ${product['price']} VND',
              ),
            ),
          );
        },
      ),
    );
  }
}