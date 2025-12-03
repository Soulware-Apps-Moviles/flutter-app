import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';
import 'package:tcompro_customer/shared/domain/shopping_list.dart';
import 'package:tcompro_customer/shared/domain/shopping_list_repository.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_event.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_state.dart';

class ShoppingListsBloc extends Bloc<ShoppingListsEvent, ShoppingListsState> {
  final ShoppingListRepository shoppingListRepository;
  final ProductRepository productRepository;
  late final StreamSubscription<ShoppingList> _listSubscription;

  ShoppingListsBloc({
    required this.shoppingListRepository,
    required this.productRepository,
  }) : super(ShoppingListsState.initial()) {
    on<LoadShoppingListsEvent>(_onLoadShoppingLists);
    on<CreateShoppingListEvent>(_onCreateShoppingList);
    on<SearchShoppingListsEvent>(_searchShoppingLists);
    on<ShoppingListUpdatedFromStream>(_onShoppingListUpdatedFromStream);
    on<AddListToBagEvent>(_onAddListToBag);
    
    _listSubscription = shoppingListRepository.listUpdates.listen((updatedList) {
      add(ShoppingListUpdatedFromStream(list: updatedList));
    });
  }

  @override
  Future<void> close() {
    _listSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onShoppingListUpdatedFromStream(
    ShoppingListUpdatedFromStream event,
    Emitter<ShoppingListsState> emit,
  ) {
    final currentLists = List<ShoppingList>.from(state.shoppingLists);
    final index = currentLists.indexWhere((l) => l.id == event.list.id);

    if (index != -1) {
      currentLists[index] = event.list;
    } else {
      currentLists.add(event.list);
    }

    emit(state.copyWith(shoppingLists: currentLists));
  }

  FutureOr<void> _onLoadShoppingLists(
    LoadShoppingListsEvent event,
    Emitter<ShoppingListsState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true, customerId: event.customerId));

      final lists = await shoppingListRepository.fetchShoppingLists(customerId: event.customerId);

      emit(state.copyWith(shoppingLists: lists, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  FutureOr<void> _searchShoppingLists(
    SearchShoppingListsEvent event,
    Emitter<ShoppingListsState> emit,
  ) async {
    final customerId = state.customerId;
    if (customerId == null) return;

    try {
      emit(state.copyWith(loading: true));
      final lists = await shoppingListRepository.fetchShoppingLists(
        customerId: customerId,
        name: event.name.isEmpty ? null : event.name,
      );
      emit(state.copyWith(shoppingLists: lists, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  FutureOr<void> _onCreateShoppingList(
    CreateShoppingListEvent event,
    Emitter<ShoppingListsState> emit,
  ) async {
    final customerId = state.customerId;
    if (customerId == null) return;

    try {
      emit(state.copyWith(loading: true));
      await shoppingListRepository.createShoppingList(
        customerId: customerId,
        name: event.name,
      );
      emit(state.copyWith(loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  FutureOr<void> _onAddListToBag(
    AddListToBagEvent event,
    Emitter<ShoppingListsState> emit,
  ) async {
    final customerId = state.customerId;
    if (customerId == null) return;

    try {
      emit(state.copyWith(loading: true));

      await Future.wait(event.list.items.map((item) {
        return productRepository.addManyToShoppingBag(
          customerId: customerId,
          product: item.product,
          quantity: item.quantity,
        );
      }));

      emit(state.copyWith(loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}