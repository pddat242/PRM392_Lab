import 'package:flutter/material.dart';
import '../services/json_storage_service.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});
  @override
  State<CrudScreen> createState() => _CrudScreenState();
}
class _CrudScreenState extends State<CrudScreen> {
  final JsonStorageService storage = JsonStorageService();
  List<Map<String, dynamic>> products = [];
  String searchQuery = '';
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
  Future<void> saveProducts() async {
    try {
      await storage.saveProducts(products);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    }
  }
  Future<void> showProductDialog({
    Map<String, dynamic>? product,
  }) async {
    final isEdit = product != null;
    String name = product?['name']?.toString() ?? '';
    String price = product?['price']?.toString() ?? '';
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Product' : 'Add Product'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  onChanged: (value) {
                    price = value;
                  },
                  validator: (value) {
                    final number = int.tryParse(value ?? '');

                    if (number == null || number <= 0) {
                      return 'Enter a valid price';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, {
                    'name': name.trim(),
                    'price': int.parse(price),
                  });
                }
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
    if (result == null || !mounted) return;
    if (isEdit) {
      final index = products.indexWhere(
        (item) => item['id'] == product['id'],
      );
      if (index == -1) return;
      setState(() {
        products[index] = {
          ...products[index],
          ...result,
        };
      });
    } else {
      int nextId = 1;
      for (final item in products) {
        final id = (item['id'] as num).toInt();
        if (id >= nextId) {
          nextId = id + 1;
        }
      }
      setState(() {
        products.add({
          'id': nextId,
          ...result,
        });
      });
    }
    await saveProducts();
  }
  Future<void> deleteProduct(Map<String, dynamic> product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text(
            'Are you sure you want to delete ${product['name']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirm != true || !mounted) return;
    setState(() {
      products.removeWhere(
        (item) => item['id'] == product['id'],
      );
    });
    await saveProducts();
  }
  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      final name = product['name'].toString().toLowerCase();

      return name.contains(searchQuery.toLowerCase());
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.3 - JSON CRUD'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredProducts.isEmpty
                      ? const Center(
                          child: Text('No products found'),
                        )
                      : ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.shopping_bag,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  product['name'].toString(),
                                ),
                                subtitle: Text(
                                  'Price: ${product['price']} VND',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Nút sửa
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () {
                                        showProductDialog(
                                          product: product,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        deleteProduct(product);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showProductDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}