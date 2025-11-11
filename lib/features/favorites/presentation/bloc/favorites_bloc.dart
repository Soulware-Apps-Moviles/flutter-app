import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/favorites/data/favorite_service.dart';
import 'package:tcompro_customer/features/favorites/domain/entities/favorite.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoriteService service;
  final int customerId;
  
  FavoritesBloc({required this.service, required this.customerId})
      : super(FavoritesState.initial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event, Emitter<FavoritesState> emit) async {
      try {
        emit(state.copyWith(loading: true));
        final favorites = await service.fetchFavorites(customerId);
        emit(state.copyWith(favoriteProducts: favorites, loading: false));
      } catch (e) {
        emit(state.copyWith(loading: false));
      }
    }

Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event, 
    Emitter<FavoritesState> emit
  ) async {
    final isFavorite = state.favoriteProducts.any(
      (f) => f.productId == event.favorite.productId,
    );

    final updated = List<Favorite>.from(state.favoriteProducts);

    if (isFavorite) {
      updated.removeWhere((f) => f.productId == event.favorite.productId);
      emit(state.copyWith(favoriteProducts: updated));

      await service.removeFavorite(customerId, event.favorite.productId);
    } else {
      updated.add(event.favorite);
      emit(state.copyWith(favoriteProducts: updated));

      await service.addFavorite(customerId, event.favorite.productId);
    }
  }
}