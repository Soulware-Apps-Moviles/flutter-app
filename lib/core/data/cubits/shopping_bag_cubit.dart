import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/shared/domain/product.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

class ShoppingBagCubit extends Cubit<ShoppingBag> {
  final ProductRepository _productRepository;

  int? _currentCustomerId;

  ShoppingBagCubit({
    required ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(ShoppingBag()) {
    _loadBagFromDb();
  }

  double get totalPrice => state.totalPrice;
  int get totalItems => state.totalItems;

  void updateCustomerId(int? customerId) {
    if (_currentCustomerId == customerId) return;
    _currentCustomerId = customerId;
  }

  Future<void> _loadBagFromDb() async {
    try {
      final items = await _productRepository.getShoppingBagItems();
      emit(ShoppingBag.fromItems(items));
    } catch (e) {
      debugPrint("Error loading shopping bag from DB: $e");
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _productRepository.addToShoppingBag(
          customerId: _currentCustomerId ?? 0, product: product);
      await _loadBagFromDb();
    } catch (e) {
      debugPrint("Error adding product to bag: $e");
    }
  }

  Future<void> removeProduct(Product product) async {
    try {
      await _productRepository.removeFromShoppingBag(
          customerId: _currentCustomerId ?? 0, product: product);
      await _loadBagFromDb();
    } catch (e) {
      debugPrint("Error removing product from bag: $e");
    }
  }

  Future<void> clear() async {
    try {
      await _productRepository.clearShoppingBag(
          customerId: _currentCustomerId ?? 0);
      emit(ShoppingBag());
    } catch (e) {
      debugPrint("Error clearing bag: $e");
    }
  }
}