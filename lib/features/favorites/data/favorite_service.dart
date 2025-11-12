import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tcompro_customer/core/constants/api_constants.dart';
import 'package:tcompro_customer/features/favorites/domain/entities/favorite.dart';

import 'package:http/http.dart' as http;

class FavoriteService {

  Future<List<Favorite>> fetchFavorites(int customerId) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl).replace(
        path: '${ApiConstants.favoritesEndpoint}/by-customer/$customerId',
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
        return data.map((e) => Favorite.fromJson(e)).toList();
      }

      throw Exception('Failed to load favorites. Status code: ${response.statusCode}');
    } catch (e, st) {
      debugPrint('Error fetchFavorites: $e\n$st');
      throw Exception('Failed to load favorites: $e');
    }
  }

  Future<void> addFavorite(int customerId, int productId) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl).replace(
        path: ApiConstants.favoritesEndpoint
      );

      debugPrint('URL: $uri');

      final String token = dotenv.env['DEV_TOKEN'] ?? '';

      final response = await http.post(
        uri,
        body: jsonEncode({
          'catalogProductId': productId,
          'customerId': customerId
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Body: ${jsonEncode({
          'catalogProductId': productId,
          'customerId': customerId
      })}');
      debugPrint('Status: ${response.statusCode}');

      if (response.statusCode != 201) {
        throw Exception('Failed to add favorite. Status code: ${response.statusCode}');
      }
    } catch (e, st) {
      debugPrint('Error addFavorite: $e\n$st');
      throw Exception('Failed to add favorite: $e');
    }
  }

    Future<void> removeFavorite(int customerId, int productId) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl).replace(
        path: ApiConstants.favoritesEndpoint
      );

      debugPrint('URL: $uri');

      final String token = dotenv.env['DEV_TOKEN'] ?? '';

      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'productId': productId,
          'customerId': customerId
        }),
      );

      debugPrint('Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Failed to remove favorite. Status code: ${response.statusCode}');
      }
    } catch (e, st) {
      debugPrint('Error removeFavorite: $e\n$st');
      throw Exception('Failed to remove favorite: $e');
    }
  }
}