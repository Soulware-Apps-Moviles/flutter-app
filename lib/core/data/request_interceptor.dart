
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tcompro_customer/core/data/cubits/token_cubit.dart';

// Allows to dynamically inject the token value into HTTP requests from services
// It does so by reading the token value from memory via TokenCubit
class RequestInterceptor extends Interceptor {
  final TokenCubit _tokenCubit;

  RequestInterceptor(this._tokenCubit);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenCubit.state;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode) {
      debugPrint('--- 🚀 DIO REQUEST ---');
      debugPrint('URI: ${options.uri}');
      debugPrint('METHOD: ${options.method}');
      debugPrint('HEADERS: ${options.headers}');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('QUERY PARAMS: ${options.queryParameters}');
      }
      if (options.data != null) {
        debugPrint('BODY: ${options.data}');
      }
      debugPrint('----------------------');
    }

    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('--- ✅ DIO RESPONSE [${response.statusCode}] ---');
      debugPrint('URI: ${response.requestOptions.uri}');
      debugPrint('DATA: ${response.data}');
      debugPrint('----------------------');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('--- ❌ DIO ERROR [${err.response?.statusCode}] ---');
      debugPrint('URI: ${err.requestOptions.uri}');
      debugPrint('MESSAGE: ${err.message}');
      debugPrint('RESPONSE: ${err.response?.data}');
      debugPrint('----------------------');
    }
    super.onError(err, handler);
  }
}