import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tcompro_customer/features/orders/domain/shop.dart';

class ShopService {
  final Dio _dio;
  static const String _shopsEndpoint = '/shops/v1';

  ShopService({required Dio dio}) : _dio = dio;

  Future<List<Shop>> fetchShopsByProducts({
    required List<int> productIds,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.post(
        '$_shopsEndpoint/by-products',
        data: {
          'ids': productIds,
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      final List data = response.data;

      return data.map((e) => Shop.fromJson(
        e, 
        userLat: latitude, 
        userLng: longitude
      )).toList();

    } catch (e, st) {
      debugPrint('Error fetchShopsByProducts: $e\n$st');
      throw Exception('Failed to load shops by products: $e');
    }
  }

  Future<Shop> fetchShopById(int id) async {
    try {
      final response = await _dio.get('$_shopsEndpoint/$id');
      final List data = response.data;
      
      return Shop.fromJson(data.first);

    } catch (e, st) {
      debugPrint('Error fetchShopById: $e\n$st');
      throw Exception('Failed to load shop: $e');
    }
  }

  Future<Shop> fetchShopByOwnerId(int ownerId) async {
    try {
      final response = await _dio.get('$_shopsEndpoint/by-owner/$ownerId');
      final List data = response.data;

      return Shop.fromJson(data.first);

    } catch (e, st) {
      debugPrint('Error fetchShopByOwnerId: $e\n$st');
      throw Exception('Failed to load shop by owner: $e');
    }
  }
}