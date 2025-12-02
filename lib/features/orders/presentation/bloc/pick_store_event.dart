import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

abstract class PickStoreEvent {}

class LoadStoresEvent extends PickStoreEvent {
  final ShoppingBag shoppingBag;

  LoadStoresEvent(this.shoppingBag);
}

class SelectShopEvent extends PickStoreEvent {
  final Shop shop;
  SelectShopEvent({required this.shop});
}