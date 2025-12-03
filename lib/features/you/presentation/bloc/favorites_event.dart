import 'package:tcompro_customer/shared/domain/product.dart';

abstract class FavoritesEvent {}

class LoadFavoritesEvent extends FavoritesEvent {
  final int customerId;
  LoadFavoritesEvent({required this.customerId});
}

class ToggleFavoriteInList extends FavoritesEvent {
  final Product product;
  ToggleFavoriteInList({required this.product});
}

class FavoriteProductUpdatedFromStream extends FavoritesEvent {
  final Product product;
  FavoriteProductUpdatedFromStream({required this.product});
}