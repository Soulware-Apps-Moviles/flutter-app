import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tcompro_customer/core/constants/api_constants.dart';
import 'package:tcompro_customer/features/orders/domain/order.dart';

class OrderService {
  final Dio _dio;

  OrderService({required Dio dio}) : _dio = dio;

  Future<List<Order>> fetchOrders({int? shopId, int? customerId, String? status}) async {
    try {
      final response = await _dio.get(
        ApiConstants.ordersEndpoint,
        queryParameters: {
          if (shopId != null) 'shopId': shopId,
          if (customerId != null) 'customerId': customerId,
          if (status != null) 'status': status,
        },
      );

      final List data = response.data;

      return data.map((e) => Order.fromJson(e)).toList();
      
    } catch (e, st) {
      debugPrint('Error fetchOrders: $e\n$st');
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<Order> createOrder({
    required int customerId,
    required int shopId,
    required String paymentMethod,
    required String pickupMethod,
    required List<Map<String, dynamic>> orderlines,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.ordersEndpoint,
        data: {
          'orderlines': orderlines,
          'customerId': customerId,
          'shopId': shopId,
          'paymentMethod': paymentMethod,
          'pickupMethod': pickupMethod,
        },
      );

      return Order.fromJson(response.data);

    } catch (e, st) {
      debugPrint('Error createOrder: $e\n$st');
      throw Exception('Failed to create order: $e');
    }
  }

  Future<void> rejectOrder(int id) async {
    try {
      await _dio.post('$ApiConstants.ordersEndpoint/$id/reject');
    } catch (e, st) {
      debugPrint('Error rejectOrder: $e\n$st');
      throw Exception('Failed to reject order: $e');
    }
  }

  Future<void> cancelOrder(int id) async {
    try {
      await _dio.post('$ApiConstants.ordersEndpoint/$id/cancel');
    } catch (e, st) {
      debugPrint('Error cancelOrder: $e\n$st');
      throw Exception('Failed to cancel order: $e');
    }
  }

  Future<void> advanceOrder(int id) async {
    try {
      await _dio.post('$ApiConstants.ordersEndpoint/$id/advance');
    } catch (e, st) {
      debugPrint('Error advanceOrder: $e\n$st');
      throw Exception('Failed to advance order: $e');
    }
  }

  Future<void> acceptOrder(int id) async {
    try {
      await _dio.post('$ApiConstants.ordersEndpoint/$id/accept');
    } catch (e, st) {
      debugPrint('Error acceptOrder: $e\n$st');
      throw Exception('Failed to accept order: $e');
    }
  }
}