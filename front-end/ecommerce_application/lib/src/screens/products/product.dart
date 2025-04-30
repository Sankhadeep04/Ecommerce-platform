import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  final int productId;

  const ProductPage({super.key, required this.productId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Map<String, dynamic>? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://yourapi.com/products/${widget.productId}',
        ), // Update with your actual API URL
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          product = data['product']; // Update to match your JSON structure
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      debugPrint('Error fetching product: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : product == null
              ? const Center(child: Text("Product not found"))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product!['image_url'], // Use 'image_url' from API
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Product Details
                    Text(
                      product!['name'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Price: ₹${product!['price'] ?? 'N/A'}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Category: ${product!['category'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Quantity: ${product!['quantity'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Added On: ${DateTime.tryParse(product!['created_at'] ?? '')?.toLocal().toString().split(' ')[0] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      product!['description'] ?? 'No description available.',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
    );
  }
}
