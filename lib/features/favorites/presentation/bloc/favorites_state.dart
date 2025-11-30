import 'package:tcompro_customer/features/favorites/domain/favorite.dart';

class FavoritesState {
  final List<Favorite> favoriteProducts;
  final bool loading;
  final int? customerId;

  FavoritesState({required this.favoriteProducts, this.loading = false, this.customerId});

  factory FavoritesState.initial() {
    return FavoritesState(favoriteProducts: []);
  }

  FavoritesState copyWith({
    List<Favorite>? favoriteProducts,
    bool? loading,
    int? customerId
  }) {
    return FavoritesState(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      loading: loading ?? this.loading,
      customerId: customerId ?? this.customerId
    );
  }
}