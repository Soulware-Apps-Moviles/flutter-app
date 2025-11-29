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
    on<SearchProductsEvent>(_searchProducts);
  }

  FutureOr<void> _loadProducts(
    LoadProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.selectedCategory == event.category && state.products.isNotEmpty) {
      return;
    }
    emit(
      state.copyWith(selectedCategory: event.category, status: Status.loading),
    );
    List<Product> products = [];
    try {
      if (event.category == CategoryType.ALL) {
        products = await repository.fetchProducts();
      } else {
        products =
            await repository.fetchProducts(category: event.category.name);
      }
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
    SearchProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final products = await repository.fetchProducts(
        name: event.name.isEmpty ? null : event.name,
        category: event.category == CategoryType.ALL.toString()
            ? null
            : event.category,
      );
      emit(state.copyWith(products: products, status: Status.loaded));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}