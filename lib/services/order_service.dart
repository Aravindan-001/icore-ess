import '../models/product.dart';
import '../models/sales_order.dart';
import '../repositories/order_repository.dart';

class OrderService {
  final OrderRepository _orderRepo;

  OrderService(this._orderRepo);

  Future<List<Product>> getProducts() => _orderRepo.getProducts();

  Future<List<SalesOrder>> getSalesOrders() => _orderRepo.getSalesOrders();

  Future<bool> placeOrder(Map<String, int> cart) {
    if (cart.isEmpty) return Future.value(false);
    return _orderRepo.placeOrder(cart);
  }
}
