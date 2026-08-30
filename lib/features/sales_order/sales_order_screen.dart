import 'package:flutter/material.dart';

class SalesOrderScreen extends StatelessWidget {
  const SalesOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Orders')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Order #SO-00${5-index}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('15 May 2024'),
              trailing: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹4,500', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Delivered', style: TextStyle(color: Colors.green, fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
