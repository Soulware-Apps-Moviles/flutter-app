import 'package:tcompro_customer/shared/domain/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts({String? category, String? name});

  void addToShoppingBag();
}