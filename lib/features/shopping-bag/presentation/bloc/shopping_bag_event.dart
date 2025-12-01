import 'package:tcompro_customer/shared/domain/product.dart';

abstract class ShoppingBagEvent {}

class LoadShoppingBag extends ShoppingBagEvent {}

class IncrementItemQuantity extends ShoppingBagEvent {
  final Product product;
  IncrementItemQuantity({required this.product});
}

class DecrementItemQuantity extends ShoppingBagEvent {
  final Product product;
  DecrementItemQuantity({required this.product});
}

class RemoveItemFromBag extends ShoppingBagEvent {
  final Product product;
  RemoveItemFromBag({required this.product});
}

class ClearShoppingBag extends ShoppingBagEvent {}