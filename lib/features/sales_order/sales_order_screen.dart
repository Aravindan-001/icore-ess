import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/utils/dependency_injection.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/sales_order.dart';

class SalesOrderScreen extends StatelessWidget {
  const SalesOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Orders')),
      body: FutureBuilder<List<SalesOrder>>(
        future: DependencyInjection.repository.getSalesOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading sales orders'));
          }

          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const EmptyState(
              title: 'No Orders',
              message: 'You haven\'t placed any orders yet.',
              icon: Icons.list_alt_outlined,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                child: ListTile(
                  title: Text(
                    'Order #${order.orderNumber}', 
                    style: const TextStyle(fontWeight: FontWeight.bold)
                  ),
                  subtitle: Text(DateFormat('dd MMM yyyy').format(order.date)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${order.amount.toStringAsFixed(0)}', 
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                      Text(
                        order.status, 
                        style: TextStyle(color: _getStatusColor(order.status), fontSize: 12)
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'processing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
