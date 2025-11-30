import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

abstract class ProductRepository {
  Stream<Product> get productUpdates;

  Future<List<Product>> fetchProducts({required int customerId, CategoryType? category, String? name});
  void addToShoppingBag({required int customerId, required Product product});
  void toggleFavorite({required int customerId, required Product product});
}