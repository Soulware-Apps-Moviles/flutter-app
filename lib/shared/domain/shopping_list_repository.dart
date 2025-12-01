import 'dart:async';
import 'package:tcompro_customer/shared/domain/product.dart';
import 'package:tcompro_customer/shared/domain/shopping_list.dart';

abstract class ShoppingListRepository {
  Stream<ShoppingList> get listUpdates;

  Future<List<ShoppingList>> fetchShoppingLists({required int customerId, String? name});
  Future<ShoppingList> createShoppingList({required int customerId, required String name});
  Future<void> addItemOrUpdateQuantity({
    required ShoppingList list,
    required Product product,
    required int newQuantity,
  });
}