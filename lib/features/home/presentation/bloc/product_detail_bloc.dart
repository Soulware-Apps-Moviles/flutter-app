import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/product_detail_event.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/product_detail_state.dart';
import 'package:tcompro_customer/shared/data/remote/shopping_list_service.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository repository;
  final ShoppingListService service;

  ProductDetailBloc({required this.repository, required this.service}) : super(const ProductDetailState()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<ToggleFavorite>(_onToggleFavorite);
    on<AddToShoppingList>(_addToShoppingList);
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
    ToggleFavorite event,
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

  FutureOr<void> _addToShoppingList(
    AddToShoppingList event,
    Emitter<ProductDetailState> emit,
  ) async {
    const int targetQuantity = 1; 

    try {
      await service.addItemOrUpdateQuantity(
        list: event.list,
        product: event.product,
        newQuantity: targetQuantity,
      );
    } catch (e) {
      emit(state.copyWith(
        errorMessage: "Failed to add to list: ${e.toString()}",
      ));
    }
  }
}