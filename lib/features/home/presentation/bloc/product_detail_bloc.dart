import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/product_detail_event.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/product_detail_state.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository repository;

  ProductDetailBloc({required this.repository}) : super(const ProductDetailState()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<ToggleDetailFavorite>(_onToggleFavorite);
  }

  FutureOr<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(
      status: ProductDetailStatus.loading,
      product: event.product,
      customerId: event.customerId,
    ));

    try {
      final relatedProducts = await repository.fetchProducts(
        customerId: event.customerId,
        category: event.product.category,
      );

      final filteredRelated = relatedProducts
          .where((p) => p.id != event.product.id)
          .toList();

      emit(state.copyWith(
        status: ProductDetailStatus.loaded,
        relatedProducts: filteredRelated,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductDetailStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  FutureOr<void> _onToggleFavorite(
    ToggleDetailFavorite event,
    Emitter<ProductDetailState> emit,
  ) async {
    final customerId = state.customerId;
    final currentProduct = state.product;

    if (customerId == null || currentProduct == null) return;

    final isCurrentlyFavorite = currentProduct.isFavorite;
    final updatedProduct = currentProduct.copyWith(isFavorite: !isCurrentlyFavorite);

    emit(state.copyWith(product: updatedProduct));

    try {
      repository.toggleFavorite(
        customerId: customerId,
        product: currentProduct,
      );
    } catch (e) {
      emit(state.copyWith(
        product: currentProduct,
        errorMessage: "Error toggling favorite: ${e.toString()}",
      ));
    }
  }
}