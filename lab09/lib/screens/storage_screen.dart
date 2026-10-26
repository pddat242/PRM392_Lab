import 'package:flutter/material.dart';
import '../services/json_storage_service.dart';
class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});
  @override
  State<StorageScreen> createState() => _StorageScreenState();
}
class _StorageScreenState extends State<StorageScreen> {
  final JsonStorageService storage = JsonStorageService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadProducts();
  }
  Future<void> loadProducts() async {
    try {
      final data = await storage.loadProducts();
      if (!mounted) return;
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Load failed: $e')),
      );
    }
  }
  void addProduct() {
    final name = nameController.text.trim();
    final price = int.tryParse(priceController.text.trim());
    if (name.isEmpty || price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter valid name and price'),
        ),
      );
      return;
    }
    int nextId = 1;
    for (final product in products) {
      final id = (product['id'] as num).toInt();
      if (id >= nextId) {
        nextId = id + 1;
      }
    }
    setState(() {
      products.add({
        'id': nextId,
        'name': name,
        'price': price,
      });
    });
    nameController.clear();
    priceController.clear();
    FocusScope.of(context).unfocus();
  }
  Future<void> saveProducts() async {
    try {
      await storage.saveProducts(products);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Products saved successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    }
  }
  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2 - JSON Storage'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addProduct,
              child: const Text('Add Product'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.shopping_bag),
                            title: Text(product['name'].toString()),
                            subtitle: Text(
                              'Price: ${product['price']} VND',
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saveProducts,
                icon: const Icon(Icons.save),
                label: const Text('Save Products'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}