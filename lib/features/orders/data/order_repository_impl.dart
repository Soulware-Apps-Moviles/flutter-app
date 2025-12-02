import 'dart:async';

import 'package:tcompro_customer/features/orders/data/location_service.dart';
import 'package:tcompro_customer/features/orders/data/order_service.dart';
import 'package:tcompro_customer/features/orders/data/shop_service.dart';
import 'package:tcompro_customer/features/orders/domain/order_repository.dart';
import 'package:tcompro_customer/features/orders/domain/shop.dart';
// ignore: unused_import
import 'package:tcompro_customer/features/orders/domain/user_location.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

class OrderRepositoryImpl implements OrderRepository {
  // ignore: unused_field
  final OrderService _orderService;
  final ShopService _shopService;
  // ignore: unused_field
  final LocationService _locationService;
  //late final StreamSubscription _bagSubscription;

  OrderRepositoryImpl({
    required OrderService orderService,
    required ShopService shopService,
    required LocationService locationService,
  }) : _orderService = orderService, _shopService = shopService, _locationService = locationService;

  @override
  FutureOr<List<Shop>> findNearbyShops(ShoppingBag shoppingBag) async {
    //UserLocation location = await _locationService.getCurrentLocation();
    final productIds = shoppingBag.items.map((item) => item.product.id).toList();

    return await _shopService.fetchShopsByProducts(
      productIds: productIds,
      //latitude: location.latitude,
      //longitude: location.longitude
      // Make me remeber to remove this before going to prod
      latitude: -12.103679,
      longitude: -76.963655
    );
  }
}