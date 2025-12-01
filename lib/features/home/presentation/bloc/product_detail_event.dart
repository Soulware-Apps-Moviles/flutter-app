import 'package:tcompro_customer/shared/domain/shopping_list.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

abstract class ProductDetailEvent {}

class LoadProductDetail extends ProductDetailEvent {
  final Product product;
  final int customerId;
  LoadProductDetail({required this.product, required this.customerId});
}

class ToggleFavorite extends ProductDetailEvent {
  final Product product;
  ToggleFavorite({required this.product});
}

class AddToShoppingList extends ProductDetailEvent {
  final Product product;
  final ShoppingList list;
  AddToShoppingList({required this.product, required this.list});
}