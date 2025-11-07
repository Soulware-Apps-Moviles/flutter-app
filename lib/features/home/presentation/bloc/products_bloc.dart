import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/home/data/product_service.dart';
import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/features/home/domain/product.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_event.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductService service;

  ProductsBloc({required this.service}) : super(ProductsState()){
    on<LoadProductsEvent>(_loadProducts);
    on<SearchProductsEvent>(_searchProducts);
  }

  FutureOr<void> _loadProducts(
    LoadProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    if (state.selectedCategory == event.category && state.products.isNotEmpty){
      return;
    }
    emit(state.copyWith(selectedCategory: event.category, status: Status.loading),);
    List<Product> products = [];
    try {
      if (event.category == CategoryType.ALL) {
        products = await service.fetchProducts();
      } else {
        products = await service.fetchProducts(category: event.category.name);
      }
      emit(state.copyWith(products: products, status: Status.loaded),);
    } catch (e) {
      emit(state.copyWith(status: Status.error),);
    }
  }

  FutureOr<void> _searchProducts(
  SearchProductsEvent event,
  Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final products = await service.fetchProducts(
        name: event.name.isEmpty ? null : event.name,
        category: event.category == CategoryType.ALL.toString() ? null : event.category,
      );
      emit(state.copyWith(products: products, status: Status.loaded));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}