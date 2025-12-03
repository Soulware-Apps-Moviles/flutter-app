import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tcompro_customer/core/constants/api_constants.dart';
import 'package:tcompro_customer/shared/domain/favorite.dart';

class FavoriteService {
  final Dio _dio;

  FavoriteService({required Dio dio}) : _dio = dio;

  Future<List<Favorite>> fetchFavorites(int customerId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.favoritesEndpoint}/by-customer/$customerId',
      );

      final List data = response.data;
      return data.map((e) => Favorite.fromJson(e)).toList();
    } catch (e, st) {
      debugPrint('Error fetchFavorites: $e\n$st');
      throw Exception('Failed to load favorites: $e');
    }
  }

  Future<List<int>> getFavoritesIds(int customerId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.favoritesEndpoint}/by-customer/$customerId',
      );

      final List data = response.data;
      return data.map((e) => Favorite.fromJson(e).productId).toList();
    } catch (e, st) {
      debugPrint('Error fetchFavorites: $e\n$st');
      throw Exception('Failed to load favorites: $e');
    }
  }

  Future<void> addFavorite(int customerId, int productId) async {
    try {
      await _dio.post(
        ApiConstants.favoritesEndpoint,
        data: {
          'catalogProductId': productId,
          'customerId': customerId
        },
      );
    } catch (e, st) {
      debugPrint('Error addFavorite: $e\n$st');
      throw Exception('Failed to add favorite: $e');
    }
  }

  Future<void> removeFavorite(int customerId, int productId) async {
    try {
      await _dio.delete(
        ApiConstants.favoritesEndpoint,
        data: {
          'productId': productId,
          'customerId': customerId
        },
      );
    } catch (e, st) {
      debugPrint('Error removeFavorite: $e\n$st');
      throw Exception('Failed to remove favorite: $e');
    }
  }
}