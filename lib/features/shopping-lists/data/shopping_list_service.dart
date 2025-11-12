import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tcompro_customer/core/constants/api_constants.dart';
import 'package:tcompro_customer/features/shopping-lists/domain/shopping_list.dart';

class ShoppingListService {

  Future<List<ShoppingList>> fetchShoppingLists(int customerId) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl).replace(
        path: '${ApiConstants.shoppingListsEndpoint}/by-customer/$customerId',
      );

      debugPrint('URL: $uri');

      final String token = dotenv.env['DEV_TOKEN'] ?? '';

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => ShoppingList.fromJson(e)).toList();
      }
      throw Exception('Failed to load shopping lists. Status code: ${response.statusCode}');
    } catch (e, st) {
      debugPrint('Error fetchShoppingLists: $e\n$st');
      throw Exception('Failed to load shopping lists: $e');
    }
  }

  Future<ShoppingList> addShoppingList(int customerId, String name) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl).replace(
        path: ApiConstants.shoppingListsEndpoint 
      );

      debugPrint('URL: $uri');

      final String token = dotenv.env['DEV_TOKEN'] ?? '';

      final response = await http.post(
        uri,
        body: jsonEncode({
          'customerId': customerId,
          'name': name,
          'items' : []
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('Status: ${response.statusCode}');
      if (response.statusCode != 201) {
        throw Exception('Failed to add shopping list. Status code: ${response.statusCode}');
      }
      final data = jsonDecode(response.body);
      return ShoppingList.fromJson(data);
    } catch (e, st) {
      debugPrint('Error addShoppingList: $e\n$st');
      throw Exception('Failed to add shopping list: $e');
    }
  }
}