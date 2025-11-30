import 'package:tcompro_customer/features/favorites/domain/favorite.dart';

abstract class FavoritesEvent {
  const FavoritesEvent();
}

class LoadFavoritesEvent extends FavoritesEvent {
  final int customerId;
  const LoadFavoritesEvent({required this.customerId});
}

class ToggleFavoriteEvent extends FavoritesEvent {
  final Favorite favorite;
  ToggleFavoriteEvent({required this.favorite});
}