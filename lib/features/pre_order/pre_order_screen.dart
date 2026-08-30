import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PreOrderScreen extends StatefulWidget {
  const PreOrderScreen({super.key});

  @override
  State<PreOrderScreen> createState() => _PreOrderScreenState();
}

class _PreOrderScreenState extends State<PreOrderScreen> {
  final List<Map<String, dynamic>> _products = [
    {'name': 'Company Hoodie', 'price': 1200, 'quantity': 0},
    {'name': 'Water Bottle', 'price': 450, 'quantity': 0},
    {'name': 'Notebook', 'price': 200, 'quantity': 0},
    {'name': 'Backpack', 'price': 1500, 'quantity': 0},
  ];

  int get _totalItems => _products.fold(0, (sum, item) => sum + (item['quantity'] as int));
  int get _totalAmount => _products.fold(0, (sum, item) => sum + ((item['quantity'] as int) * (item['price'] as int)));

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQty = (_products[index]['quantity'] as int) + delta;
      if (newQty >= 0) {
        _products[index]['quantity'] = newQty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company Store')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                final qty = product['quantity'] as int;

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.grey.shade200,
                          child: const Center(child: Icon(Icons.image, size: 48, color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('₹${product['price']}', style: const TextStyle(color: AppTheme.primaryBlue)),
                            const SizedBox(height: 8),
                            if (qty == 0)
                              ElevatedButton(
                                onPressed: () => _updateQuantity(index, 1),
                                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 36)),
                                child: const Text('Add', style: TextStyle(fontSize: 12)),
                              )
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                                    onPressed: () => _updateQuantity(index, -1),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, size: 20),
                                    onPressed: () => _updateQuantity(index, 1),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_totalItems > 0)
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$_totalItems Items', style: Theme.of(context).textTheme.bodySmall),
                        Text('₹$_totalAmount', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order placed successfully')),
                          );
                          setState(() {
                            for (var p in _products) {
                              p['quantity'] = 0;
                            }
                          });
                        },
                        child: const Text('Place Order'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
