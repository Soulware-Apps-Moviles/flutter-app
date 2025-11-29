import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/home_event.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/home_state.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository repository;

  HomeBloc({required this.repository}) : super(HomeState()) {
    on<LoadProductsEvent>(_loadProducts);
    on<SearchQuerySent>(_searchProducts);
    on<CategoryChanged>(_categoryChanged);
  }

  FutureOr<void> _loadProducts(
    LoadProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.selectedCategory == event.category && state.products.isNotEmpty && state.customerId == event.customerId) {
      return;
    }
    
    emit(
      state.copyWith(
        selectedCategory: event.category, 
        status: Status.loading,
        customerId: event.customerId,
      ),
    );
    List<Product> products = [];
    try {
      final CategoryType? categoryFilter = event.category == CategoryType.ALL ? null : event.category;

      products = await repository.fetchProducts(
        customerId: event.customerId,
        category: categoryFilter,
      );

      emit(
        state.copyWith(products: products, status: Status.loaded),
      );
    } catch (e) {
      emit(
        state.copyWith(status: Status.error),
      );
    }
  }

  FutureOr<void> _searchProducts(
    SearchQuerySent event,
    Emitter<HomeState> emit,
  ) async {
    final customerId = state.customerId;

    if (customerId == null) {
      emit(state.copyWith(status: Status.error, errorMessage: "Customer ID not loaded for search."));
      return;
    }

    emit(state.copyWith(status: Status.loading));
    try {
      final products = await repository.fetchProducts(
        customerId: customerId,
        name: event.query.isEmpty ? null : event.query,
        category: event.category == CategoryType.ALL
            ? null
            : event.category,
      );
      emit(state.copyWith(products: products, status: Status.loaded));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _categoryChanged(
    CategoryChanged event,
    Emitter<HomeState> emit,
  ) async {
    final customerId = state.customerId;

    if (customerId == null) {
      emit(state.copyWith(status: Status.error, errorMessage: "Customer ID not loaded. Cannot change category."));
      return;
    }

    if (state.selectedCategory == event.category && state.products.isNotEmpty) {
      return;
    }

    emit(
      state.copyWith(selectedCategory: event.category, status: Status.loading),
    );

    try {
      final CategoryType? categoryFilter = event.category == CategoryType.ALL ? null : event.category;

      final products = await repository.fetchProducts(
        customerId: customerId,
        category: categoryFilter,
      );

      emit(
        state.copyWith(products: products, status: Status.loaded),
      );
    } catch (e) {
      emit(
        state.copyWith(status: Status.error, errorMessage: e.toString()),
      );
    }
  }
}