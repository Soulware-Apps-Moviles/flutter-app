import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tcompro_customer/core/constants/api_constants.dart';
import 'package:tcompro_customer/features/home/domain/product.dart';

class ProductService {
  final Dio _dio;

  ProductService({required Dio dio}) : _dio = dio;

  Future<List<Product>> fetchProducts({String? category, String? name, int? id}) async {
    try {
      final response = await _dio.get(
        ApiConstants.productsEndpoint,
        queryParameters: {
          if (category != null) 'category': category,
          if (name != null) 'name': name,
          if (id != null) 'id': id,
        },
      );

      final List data = response.data;

      return data.map((e) => Product.fromJson(e)).toList();
      
    } catch (e, st) {
      debugPrint('Error fetchProducts: $e\n$st');
      throw Exception('Failed to load products: $e');
    }
  }
}