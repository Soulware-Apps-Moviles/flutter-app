import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:tcompro_customer/constants/api_constants.dart';
import 'package:tcompro_customer/features/home/domain/product.dart';

class ProductService {

  // ALL PRODUCTS BY CATEGORY
  Future<List<Product>> fetchProducts({String? category, String? name, Long? id}) async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl).replace(
        path: ApiConstants.productsEndpoint,
        queryParameters: {
          if (category != null) 'category': category,
          if (name != null) 'name': name,
          if (id != null) 'id': id,
        },
      );

      debugPrint('URL: $uri');

      //TO TESTING WITH DEV TOKEN
      final String token = dotenv.env['DEV_TOKEN'] ?? '';

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Status: ${response.statusCode}');

      if (response.statusCode == HttpStatus.ok) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Product.fromJson(e)).toList();
      }

      throw HttpException('Status code: ${response.statusCode}');
    } catch (e, st) {
      debugPrint('Error fetchProductsByCategory: $e\n$st');
      throw Exception('Failed to load products by category: $e');
    }
  }
}