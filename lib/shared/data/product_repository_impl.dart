import 'dart:async';

import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/shared/data/local/shopping_bag_dao.dart';
import 'package:tcompro_customer/shared/data/remote/favorite_service.dart';
import 'package:tcompro_customer/shared/data/remote/product_service.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag_item.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductService _productService;
  final FavoriteService _favoriteService;
  final ShoppingBagDao _shoppingBagDao;

  final _productUpdateController = StreamController<Product>.broadcast();
  final _bagUpdateController = StreamController<void>.broadcast();

  @override
  Stream<Product> get productUpdates => _productUpdateController.stream;

  @override
  Stream<void> get bagUpdates => _bagUpdateController.stream;

  ProductRepositoryImpl({
    required ProductService productService,
    required FavoriteService favoriteService,
    required ShoppingBagDao shoppingBagDao
  }) : _productService = productService, _favoriteService = favoriteService, _shoppingBagDao = shoppingBagDao;

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
        return product.copyWith(isFavorite: isFav); 
      }

      return product;
    }).toList();

    return markedProducts;
  }

  @override
  Future<List<Product>> fetchFavorites(
      {required int customerId, CategoryType? category, String? name}) async {
    List<Product> allProducts = await _productService.fetchProducts(
        category: category?.stringName, name: name);
    
    List<int> favoriteIds = await _favoriteService.getFavoritesIds(customerId);
    final favoriteSet = favoriteIds.toSet();

    final favoriteProducts = allProducts
        .where((product) => favoriteSet.contains(product.id))
        .map((product) => product.copyWith(isFavorite: true))
        .toList();

    return favoriteProducts;
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
  Future<void> addOneToShoppingBag({required int customerId, required Product product}) async {  
    final currentItems = await _shoppingBagDao.fetchBagItems();
    final existingIndex = currentItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      final existingItem = currentItems[existingIndex];
      await _shoppingBagDao.updateQuantity(product.id, existingItem.quantity + 1);
    } else {
      final newItem = ShoppingBagItem(product: product, quantity: 1);
      await _shoppingBagDao.insertOrUpdate(newItem);
    }

    _bagUpdateController.add(null); 
  }

  @override
  Future<void> addManyToShoppingBag({required int customerId, required Product product, required int quantity}) async {  
    final currentItems = await _shoppingBagDao.fetchBagItems();
    final existingIndex = currentItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      final existingItem = currentItems[existingIndex];
      await _shoppingBagDao.updateQuantity(product.id, existingItem.quantity + quantity);
    } else {
      final newItem = ShoppingBagItem(product: product, quantity: quantity);
      await _shoppingBagDao.insertOrUpdate(newItem);
    }

    _bagUpdateController.add(null); 
  }

  @override
  Future<void> decreaseQuantity({required int customerId, required Product product}) async {
    final currentItems = await _shoppingBagDao.fetchBagItems();
    final existingIndex = currentItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      final existingItem = currentItems[existingIndex];
      if (existingItem.quantity > 1) {
        await _shoppingBagDao.updateQuantity(product.id, existingItem.quantity - 1);
      } else {
        await _shoppingBagDao.delete(product.id);
      }
      _bagUpdateController.add(null);
    }
  }

  @override
  Future<void> removeFromShoppingBag({required int customerId, required Product product}) async {
    final currentItems = await _shoppingBagDao.fetchBagItems();
    final existingIndex = currentItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
       await _shoppingBagDao.delete(product.id);
       _bagUpdateController.add(null);
    }
  }

  @override
  Future<void> clearShoppingBag({required int customerId}) async {
    await _shoppingBagDao.clearAll();
    _bagUpdateController.add(null);
  }

  @override
  Future<List<ShoppingBagItem>> getShoppingBagItems() async {
    return await _shoppingBagDao.fetchBagItems();
  }
}