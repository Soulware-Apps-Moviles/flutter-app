import 'package:tcompro_customer/features/orders/domain/payment_method.dart';
import 'package:tcompro_customer/features/orders/domain/pickup_method.dart';
import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

abstract class OrderReviewEvent {}

class LoadOrderReviewEvent extends OrderReviewEvent {
  final Shop shop;
  final ShoppingBag shoppingBag;
  final int customerId;

  LoadOrderReviewEvent({
    required this.shop,
    required this.shoppingBag,
    required this.customerId,
  });
}

class ChangePaymentMethodEvent extends OrderReviewEvent {
  final PaymentMethod method;

  ChangePaymentMethodEvent({required this.method});
}

class ChangePickupMethodEvent extends OrderReviewEvent {
  final PickupMethod method;

  ChangePickupMethodEvent({required this.method});
}

class PlaceOrderEvent extends OrderReviewEvent {
  PlaceOrderEvent();
}