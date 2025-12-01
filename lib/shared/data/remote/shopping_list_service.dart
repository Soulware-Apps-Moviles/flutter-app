import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tcompro_customer/core/constants/api_constants.dart';
import 'package:tcompro_customer/shared/domain/product.dart';
import 'package:tcompro_customer/shared/domain/shopping_list.dart';

// Man was this a headache to deal with ...
// Ill never allow any backend implementation without streamlining
// the front-end application user flows first
// Maybe its time for an "User-Flow Driven Development"
class ShoppingListService {
  final Dio _dio;

  ShoppingListService({required Dio dio}) : _dio = dio;

  Future<List<ShoppingList>> fetchShoppingLists({required int customerId, String? name}) async {
    try {
      final response = await _dio.get(
        ApiConstants.shoppingListsEndpoint,
        queryParameters: {
          'customerId': customerId,
          if (name != null) 'name': name,
        },
      );

      final List data = response.data;
      return data.map((e) => ShoppingList.fromJson(e)).toList();
    } catch (e, st) {
      debugPrint('Error fetchShoppingLists: $e\n$st');
      throw Exception('Failed to load shopping lists: $e');
    }
  }

  Future<ShoppingList> createShoppingList(int customerId, String name) async {
    try {
      final response = await _dio.post(
        ApiConstants.shoppingListsEndpoint,
        data: {
          'customerId': customerId,
          'name': name,
          'items': [],
        },
      );

      return ShoppingList.fromJson(response.data);
    } catch (e, st) {
      debugPrint('Error createShoppingList: $e\n$st');
      throw Exception('Failed to add shopping list: $e');
    }
  }

  Future<void> _executeTogglePatch({
    required int listId,
    required int productId,
    required int quantity,
    String? newName,
  }) async {
    final Map<String, dynamic> data = {};

    if (productId > 0) {
      data['item'] = {
        'productCatalogId': productId,
        'quantity': quantity,
      };
    }

    if (newName != null) {
      data['name'] = newName;
    }
    
    try {
      await _dio.patch(
        '${ApiConstants.shoppingListsEndpoint}/$listId', 
        data: data,
      );
    } catch (e, st) {
      debugPrint('Error _executeTogglePatch: $e\n$st');
      throw Exception('Failed to execute toggle patch on list: $e');
    }
  }

  Future<void> addItemOrUpdateQuantity({
    required ShoppingList list,
    required Product product,
    required int newQuantity,
  }) async {
    final bool isProductInList = list.items.any((item) => item.catalogProductId == product.id);
    final int listId = list.id;
    final int productId = product.id;

    if (newQuantity <= 0) {
      if (isProductInList) {
        await _executeTogglePatch(
          listId: listId, 
          productId: productId, 
          quantity: 1,
        );
      }
    } else if (isProductInList) {
      await _executeTogglePatch(
        listId: listId, 
        productId: productId, 
        quantity: 1, 
      );
      
      await _executeTogglePatch(
        listId: listId, 
        productId: productId, 
        quantity: newQuantity,
      );

    } else {
      await _executeTogglePatch(
        listId: listId, 
        productId: productId, 
        quantity: newQuantity,
      );
    }
  }
}