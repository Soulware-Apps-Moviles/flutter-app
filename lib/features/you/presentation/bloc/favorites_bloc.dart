import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/you/presentation/bloc/favorites_event.dart';
import 'package:tcompro_customer/features/you/presentation/bloc/favorites_state.dart';
import 'package:tcompro_customer/shared/domain/product.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final ProductRepository productRepository;
  late final StreamSubscription<Product> _productSubscription;

  FavoritesBloc({
    required this.productRepository,
  }) : super(const FavoritesState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteInList>(_onToggleFavorite);
    on<FavoriteProductUpdatedFromStream>(_onProductUpdatedFromStream);

    _productSubscription = productRepository.productUpdates.listen((product) {
      add(FavoriteProductUpdatedFromStream(product: product));
    });
  }

  @override
  Future<void> close() {
    _productSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading, customerId: event.customerId));

    try {
      final favorites = await productRepository.fetchFavorites(
        customerId: event.customerId,
      );
      
      emit(state.copyWith(
        status: FavoritesStatus.loaded,
        products: favorites,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FavoritesStatus.error,
        errorMessage: "Failed to load favorites: ${e.toString()}",
      ));
    }
  }

  FutureOr<void> _onToggleFavorite(
    ToggleFavoriteInList event,
    Emitter<FavoritesState> emit,
  ) async {
    final customerId = state.customerId;
    if (customerId == null) return;

    final currentProducts = List<Product>.from(state.products);
    currentProducts.removeWhere((p) => p.id == event.product.id);
    
    emit(state.copyWith(products: currentProducts));

    try {
      productRepository.toggleFavorite(
        customerId: customerId,
        product: event.product,
      );
    } catch (e) {
      add(LoadFavoritesEvent(customerId: customerId));
      emit(state.copyWith(errorMessage: "Error updating favorite"));
    }
  }

  FutureOr<void> _onProductUpdatedFromStream(
    FavoriteProductUpdatedFromStream event,
    Emitter<FavoritesState> emit,
  ) {
    final updatedProduct = event.product;
    final currentProducts = List<Product>.from(state.products);
    final index = currentProducts.indexWhere((p) => p.id == updatedProduct.id);

    if (updatedProduct.isFavorite) {
      if (index == -1) {
        currentProducts.add(updatedProduct);
      } else {
        currentProducts[index] = updatedProduct;
      }
    } else {
      if (index != -1) {
        currentProducts.removeAt(index);
      }
    }

    emit(state.copyWith(products: currentProducts));
  }
}