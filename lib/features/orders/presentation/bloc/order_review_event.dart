import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

abstract class OrderReviewEvent {}

class LoadOrderReviewEvent extends OrderReviewEvent {
  final Shop shop;
  final ShoppingBag shoppingBag;

  LoadOrderReviewEvent({
    required this.shop,
    required this.shoppingBag,
  });
}