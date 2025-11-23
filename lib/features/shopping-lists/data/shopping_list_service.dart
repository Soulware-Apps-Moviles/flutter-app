import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tcompro_customer/core/constants/api_constants.dart';
import 'package:tcompro_customer/features/shopping-lists/domain/shopping_list.dart';

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

  Future<ShoppingList> addShoppingList(int customerId, String name) async {
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
      debugPrint('Error addShoppingList: $e\n$st');
      throw Exception('Failed to add shopping list: $e');
    }
  }
}