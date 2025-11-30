import 'package:tcompro_customer/shared/domain/product.dart';

abstract class ProductDetailEvent {}

class LoadProductDetail extends ProductDetailEvent {
  final Product product;
  final int customerId;
  LoadProductDetail({required this.product, required this.customerId});
}

class ToggleDetailFavorite extends ProductDetailEvent {
  final Product product;
  ToggleDetailFavorite({required this.product});
}