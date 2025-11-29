import 'package:tcompro_customer/features/home/data/product_service.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductService _service;

  ProductRepositoryImpl({required ProductService service}) : _service = service;

  @override
  Future<List<Product>> fetchProducts({String? category, String? name}) {
    return _service.fetchProducts(category: category, name: name);
  }

  @override
  void addToShoppingBag() {
    
  }
}