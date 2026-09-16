import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dependency_injection.dart';
import '../../models/product.dart';

class PreOrderScreen extends StatefulWidget {
  const PreOrderScreen({super.key});

  @override
  State<PreOrderScreen> createState() => _PreOrderScreenState();
}

class _PreOrderScreenState extends State<PreOrderScreen> {
  List<Product>? _products;
  final Map<String, int> _cart = {};
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await DependencyInjection.orderService.getProducts();
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  int get _totalItems => _cart.values.fold(0, (sum, qty) => sum + qty);
  double get _totalAmount {
    if (_products == null) return 0;
    double total = 0;
    _cart.forEach((productId, qty) {
      final product = _products!.firstWhere((p) => p.id == productId);
      total += product.price * qty;
    });
    return total;
  }

  void _updateQuantity(String productId, int delta) {
    setState(() {
      final currentQty = _cart[productId] ?? 0;
      final newQty = currentQty + delta;
      if (newQty <= 0) {
        _cart.remove(productId);
      } else {
        _cart[productId] = newQty;
      }
    });
  }

  Future<void> _handlePlaceOrder() async {
    setState(() => _isSubmitting = true);
    try {
      final success = await DependencyInjection.orderService.placeOrder(_cart);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully'), backgroundColor: AppTheme.success),
        );
        setState(() => _cart.clear());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company Store')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                    itemCount: _products!.length,
                    itemBuilder: (context, index) {
                      final product = _products![index];
                      final qty = _cart[product.id] ?? 0;

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
                                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(color: AppTheme.primaryBlue)),
                                  const SizedBox(height: 8),
                                  if (qty == 0)
                                    ElevatedButton(
                                      onPressed: () => _updateQuantity(product.id, 1),
                                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 36)),
                                      child: const Text('Add', style: TextStyle(fontSize: 12)),
                                    )
                                  else
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                                          onPressed: () => _updateQuantity(product.id, -1),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle_outline, size: 20),
                                          onPressed: () => _updateQuantity(product.id, 1),
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
                              Text('₹${_totalAmount.toStringAsFixed(0)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _handlePlaceOrder,
                              child: _isSubmitting 
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('Place Order'),
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
