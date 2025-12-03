import 'dart:async';
import 'package:tcompro_customer/features/orders/domain/order.dart';
import 'package:tcompro_customer/features/orders/domain/payment_method.dart';
import 'package:tcompro_customer/features/orders/domain/pickup_method.dart';
import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag_item.dart';

abstract class OrderRepository {
  FutureOr<List<Shop>> findNearbyShops(ShoppingBag shoppingBag);
  Future<Order> createOrder({
    required int customerId,
    required int shopId,
    required List<ShoppingBagItem> items,
    required PaymentMethod paymentMethod,
    required PickupMethod pickupMethod,
    required double totalAmount,
  });
}