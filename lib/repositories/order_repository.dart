import '../models/product.dart';
import '../models/sales_order.dart';

abstract class OrderRepository {
  Future<List<Product>> getProducts();
  Future<List<SalesOrder>> getSalesOrders();
  Future<bool> placeOrder(Map<String, int> cart);
}
