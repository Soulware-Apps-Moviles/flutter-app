import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag_item.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

abstract class ProductRepository {
  Stream<Product> get productUpdates;
  Stream<void> get bagUpdates;

  Future<List<Product>> fetchProducts({required int customerId, CategoryType? category, String? name});
  Future<List<Product>> fetchFavorites({required int customerId, CategoryType? category, String? name});
  void toggleFavorite({required int customerId, required Product product});
  Future<void> addOneToShoppingBag({required int customerId, required Product product});
  Future<void> addManyToShoppingBag({required int customerId, required Product product, required int quantity});
  Future<void> decreaseQuantity({required int customerId, required Product product});
  Future<void> removeFromShoppingBag({required int customerId, required Product product});
  Future<void> clearShoppingBag({required int customerId});
  Future<List<ShoppingBagItem>> getShoppingBagItems();
}