import 'dart:ffi';

import 'package:tcompro_customer/features/favorites/domain/entities/favorite.dart';

abstract class FavoritesEvent {}

class LoadFavoritesEvent extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final Favorite favorite;
  ToggleFavoriteEvent({required this.favorite});
}