import 'dart:async';

import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/shared/data/local/shopping_bag_dao.dart';
import 'package:tcompro_customer/shared/data/remote/favorite_service.dart';
import 'package:tcompro_customer/shared/data/remote/product_service.dart';
import 'package:tcompro_customer/shared/domain/bag_item.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductService _productService;
  final FavoriteService _favoriteService;
  final ShoppingBagDao _shoppingBagDao;

  final _productUpdateController = StreamController<Product>.broadcast();

  @override
  Stream<Product> get productUpdates => _productUpdateController.stream;

  ProductRepositoryImpl({
    required ProductService productService,
    required FavoriteService favoriteService,
    required ShoppingBagDao shopping_bag_dao
  }) : _productService = productService, _favoriteService = favoriteService, _shoppingBagDao = shopping_bag_dao;

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

    await _shoppingBagDao.updateFavoriteStatus(updatedProduct.id, updatedProduct.isFavorite);

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
      await _shoppingBagDao.updateFavoriteStatus(product.id, product.isFavorite);
      rethrow;
    }
  }
  
  @override
  Future<void> addToShoppingBag({required int customerId, required Product product}) async {  
    final currentItems = await _shoppingBagDao.fetchBagItems();
    final existingIndex = currentItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      final existingItem = currentItems[existingIndex];
      await _shoppingBagDao.updateQuantity(product.id, existingItem.quantity + 1);
    } else {
      final newItem = BagItem(product: product, quantity: 1);
      await _shoppingBagDao.insertOrUpdate(newItem);
    }
  }

  @override
  Future<void> removeFromShoppingBag({required int customerId, required Product product}) async {
    final currentItems = await _shoppingBagDao.fetchBagItems();
    final existingIndex = currentItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
       await _shoppingBagDao.delete(product.id);
    }
  }

  @override
  Future<void> clearShoppingBag({required int customerId}) async {
    await _shoppingBagDao.clearAll();
  }

  @override
  Future<List<BagItem>> getShoppingBagItems() async {
    return await _shoppingBagDao.fetchBagItems();
  }
}