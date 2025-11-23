import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tcompro_customer/core/constants/api_constants.dart';
import 'package:tcompro_customer/shared/domain/profile.dart';

class ProfileService {
  final Dio _dio;

  ProfileService({required Dio dio}) : _dio = dio;

  Future<Profile> fetchProfile({required String authId, required String role}) async {
    try {
      final response = await _dio.get(
        "${ApiConstants.authEndpoint}/by-auth-id/$authId",
        queryParameters: {
          'role': role,
        },
      );

      return Profile.fromJson(response.data);
      
    } catch (e, st) {
      debugPrint('Error fetchProfile: $e\n$st');
      throw Exception('Failed to load profile: $e');
    }
  }
}