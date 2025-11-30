import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/shared/data/remote/favorite_service.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoriteService service;
  
  FavoritesBloc({required this.service}) : super(FavoritesState.initial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event, Emitter<FavoritesState> emit) async {
      try {
        emit(state.copyWith(
          loading: true, 
          customerId: event.customerId
        ));

        // Usamos el ID del evento para la petición
        final favorites = await service.fetchFavorites(event.customerId);
        
        emit(state.copyWith(favoriteProducts: favorites, loading: false));
      } catch (e) {
        emit(state.copyWith(loading: false));
      }
    }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<FavoritesState> emit) async {
    final customerId = state.customerId;
    if (customerId == null) return; 

    final isFavorite = state.favoriteProducts.any(
      (f) => f.productId == event.favorite.productId,
    );

    if (isFavorite) {
       await service.removeFavorite(customerId, event.favorite.productId);
    } else {
       await service.addFavorite(customerId, event.favorite.productId);
    }
  }
}