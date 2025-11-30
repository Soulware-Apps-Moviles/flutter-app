import 'dart:async';

import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/shared/data/favorite_service.dart';
import 'package:tcompro_customer/shared/data/product_service.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductService _productService;
  final FavoriteService _favoriteService;

  final _productUpdateController = StreamController<Product>.broadcast();

  @override
  Stream<Product> get productUpdates => _productUpdateController.stream;

  ProductRepositoryImpl(
      {required ProductService productService,
      required FavoriteService favoriteService})
      : _productService = productService,
        _favoriteService = favoriteService;

  @override
  Future<List<Product>> fetchProducts(
      {required int customerId, CategoryType? category, String? name}) async {
    List<Product> allProducts = await _productService.fetchProducts(
        category: category?.stringName, name: name);
    List<int> favoriteIds = await _favoriteService.getFavoritesIds(customerId);
    final favoriteSet = favoriteIds.toSet();

    final markedProducts = allProducts.map((product) {
      final isFav = favoriteSet.contains(product.id);
      if (isFav) {
        return product.copyWith(isFavorite: isFav); // Domain initializes products with isFavoriteFalse
      }

      return product;
    }).toList();

    return markedProducts;
  }

  @override
  Future<void> toggleFavorite(
      {required int customerId, required Product product}) async {
    final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);
    _productUpdateController.add(updatedProduct);

    try {
      final productId = product.id;
      final isFavorite = product.isFavorite;

      if (isFavorite) {
        await _favoriteService.removeFavorite(customerId, productId);
      } else {
        await _favoriteService.addFavorite(customerId, productId);
      }
    } catch (e) {
      _productUpdateController.add(product);
      rethrow;
    }
  }
  
  @override
  void addToShoppingBag({required int customerId, required Product product}) {
    // TODO: implement addToShoppingBag
  }
}