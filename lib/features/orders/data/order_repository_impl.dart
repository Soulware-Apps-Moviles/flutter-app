import 'dart:async';

import 'package:tcompro_customer/features/orders/data/location_service.dart';
import 'package:tcompro_customer/features/orders/data/order_service.dart';
import 'package:tcompro_customer/features/orders/data/shop_service.dart';
import 'package:tcompro_customer/features/orders/domain/order.dart';
import 'package:tcompro_customer/features/orders/domain/order_repository.dart';
import 'package:tcompro_customer/features/orders/domain/payment_method.dart';
import 'package:tcompro_customer/features/orders/domain/pickup_method.dart';
import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag_item.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderService _orderService;
  final ShopService _shopService;
  // ignore: unused_field
  final LocationService _locationService;

  OrderRepositoryImpl({
    required OrderService orderService,
    required ShopService shopService,
    required LocationService locationService,
  })  : _orderService = orderService,
        _shopService = shopService,
        _locationService = locationService;

  @override
  FutureOr<List<Shop>> findNearbyShops(ShoppingBag shoppingBag) async {
    // UserLocation location = await _locationService.getCurrentLocation();
    final productIds =
        shoppingBag.items.map((item) => item.product.id).toList();

    return await _shopService.fetchShopsByProducts(
        productIds: productIds,
        // latitude: location.latitude,
        // longitude: location.longitude
        // Make me remeber to remove this before going to prod
        latitude: -12.103679,
        longitude: -76.963655);
  }

  @override
  Future<Order> createOrder({
    required int customerId,
    required int shopId,
    required List<ShoppingBagItem> items,
    required PaymentMethod paymentMethod,
    required PickupMethod pickupMethod,
    required double totalAmount,
  }) async {
    final orderlines = items.map((item) {
      return {
        'productCatalogId': item.product.id,
        'quantity': item.quantity,
        'unitPrice': item.product.price,
      };
    }).toList();

    final paymentMethodStr = paymentMethod.name;
    final pickupMethodStr = pickupMethod.name;

    return await _orderService.createOrder(
      customerId: customerId,
      shopId: shopId,
      paymentMethod: paymentMethodStr,
      pickupMethod: pickupMethodStr,
      orderlines: orderlines,
    );
  }
}