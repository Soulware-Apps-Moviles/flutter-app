import 'package:geolocator/geolocator.dart';
import 'package:tcompro_customer/features/orders/domain/payment_method.dart';
import 'package:tcompro_customer/features/orders/domain/pickup_method.dart';

class Shop {
  final int id;
  final int ownerId;
  final List<PaymentMethod> paymentMethods;
  final List<PickupMethod> pickupMethods;
  final double maxCreditPerCustomer;
  final double latitude;
  final double longitude;
  final String name;
  final double? distanceInMeters;

  Shop({
    required this.id,
    required this.ownerId,
    required this.paymentMethods,
    required this.pickupMethods,
    required this.maxCreditPerCustomer,
    required this.latitude,
    required this.longitude,
    required this.name,
    this.distanceInMeters,
  });

  factory Shop.fromJson(Map<String, dynamic> json, {double? userLat, double? userLng}) {
    double shopLat = json['latitude'].toDouble();
    double shopLng = json['longitude'].toDouble();
    double? calculatedDistance;

    if (userLat != null && userLng != null) {
      calculatedDistance = Geolocator.distanceBetween(
        userLat,
        userLng,
        shopLat,
        shopLng,
      );
    }

    return Shop(
      id: json['id'],
      ownerId: json['ownerId'],
      paymentMethods: (json['paymentMethods'] as List)
          .map((e) => PaymentMethod.fromString(e))
          .toList(),
      pickupMethods: (json['pickupMethods'] as List)
          .map((e) => PickupMethod.fromString(e))
          .toList(),
      maxCreditPerCustomer: json['maxCreditPerCustomer'].toDouble(),
      latitude: shopLat,
      longitude: shopLng,
      name: json['name'],
      distanceInMeters: calculatedDistance,
    );
  }

  Shop copyWith({
    int? id,
    int? ownerId,
    List<PaymentMethod>? paymentMethods,
    List<PickupMethod>? pickupMethods,
    double? maxCreditPerCustomer,
    double? latitude,
    double? longitude,
    String? name,
  }) {
    return Shop(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      pickupMethods: pickupMethods ?? this.pickupMethods,
      maxCreditPerCustomer: maxCreditPerCustomer ?? this.maxCreditPerCustomer,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
    );
  }
}