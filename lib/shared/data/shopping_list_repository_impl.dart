import 'dart:async';

import 'package:tcompro_customer/shared/data/remote/shopping_list_service.dart';
import 'package:tcompro_customer/shared/domain/product.dart';
import 'package:tcompro_customer/shared/domain/shopping_list.dart';
import 'package:tcompro_customer/shared/domain/shopping_list_repository.dart';

class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final ShoppingListService _service;
  final _listUpdateController = StreamController<ShoppingList>.broadcast();

  ShoppingListRepositoryImpl({required ShoppingListService service})
      : _service = service;

  @override
  Stream<ShoppingList> get listUpdates => _listUpdateController.stream;

  @override
  Future<List<ShoppingList>> fetchShoppingLists({required int customerId, String? name}) async {
    return await _service.fetchShoppingLists(customerId: customerId, name: name);
  }

  @override
  Future<ShoppingList> createShoppingList({required int customerId, required String name}) async {
    final newList = await _service.createShoppingList(customerId, name);
    _listUpdateController.add(newList);
    return newList;
  }

  @override
  Future<void> addItemOrUpdateQuantity({
    required ShoppingList list,
    required Product product,
    required int newQuantity,
  }) async {
    await _service.addItemOrUpdateQuantity(
      list: list,
      product: product,
      newQuantity: newQuantity,
    );

    final refreshedLists = await _service.fetchShoppingLists(customerId: list.customerId);
    
    try {
      final updatedList = refreshedLists.firstWhere((l) => l.id == list.id);
      _listUpdateController.add(updatedList);
    } catch (_) {
      // Ignored if list is not found after update
    }
  }
}