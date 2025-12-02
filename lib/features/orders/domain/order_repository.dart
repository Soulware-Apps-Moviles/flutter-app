import 'dart:async';

import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

abstract class OrderRepository {
  FutureOr<List<Shop>> findNearbyShops(ShoppingBag shoppingBag);
}