import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tcompro_customer/features/orders/domain/user_location.dart';

class LocationService {
  Future<UserLocation> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      final position = await Geolocator.getCurrentPosition();

      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      
    } catch (e, st) {
      debugPrint('Error getCurrentLocation: $e\n$st');
      throw Exception('Failed to get current location: $e');
    }
  }
}