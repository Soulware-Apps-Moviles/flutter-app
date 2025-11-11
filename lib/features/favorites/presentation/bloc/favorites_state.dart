import 'package:tcompro_customer/features/favorites/domain/entities/favorite.dart';

class FavoritesState {
  final List<Favorite> favoriteProducts;
  final bool loading;

  FavoritesState({required this.favoriteProducts, this.loading = false});

  factory FavoritesState.initial() {
    return FavoritesState(favoriteProducts: []);
  }

  FavoritesState copyWith({
    List<Favorite>? favoriteProducts,
    bool? loading,
  }) {
    return FavoritesState(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      loading: loading ?? this.loading,
    );
  }
}