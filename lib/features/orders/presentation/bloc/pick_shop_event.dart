import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

abstract class PickShopEvent {}

class LoadShopEvent extends PickShopEvent {
  final ShoppingBag shoppingBag;

  LoadShopEvent(this.shoppingBag);
}

class SelectShopEvent extends PickShopEvent {
  final Shop shop;
  SelectShopEvent({required this.shop});
}