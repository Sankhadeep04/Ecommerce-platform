import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Simulating order history list
  final List<Map<String, dynamic>> orderHistory = const [
    // Uncomment below to simulate history data
    {
      'image': 'assets/products/converse.jpeg',
      'name': 'Nike Air Max 90',
      'description': 'Classic running sneakers',
      'quantity': 2,
      'orderDate': '2025-04-25',
    },
    {
      'image': 'assets/products/samba.jpeg',
      'name': 'Adidas Samba OG',
      'description': 'Retro stylish sneakers',
      'quantity': 1,
      'orderDate': '2025-04-20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: orderHistory.isEmpty ? _buildEmptyHistory() : _buildOrderList(),
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shopping-bag.png', // Make sure this image exists
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 20),
          const Text(
            "You should start shopping now",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    return ListView.builder(
      itemCount: orderHistory.length,
      itemBuilder: (context, index) {
        final order = orderHistory[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                order['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              order['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order['description']),
                const SizedBox(height: 4),
                Text("Quantity: ${order['quantity']}"),
                Text("Order Date: ${order['orderDate']}"),
              ],
            ),
          ),
        );
      },
    );
  }
}
