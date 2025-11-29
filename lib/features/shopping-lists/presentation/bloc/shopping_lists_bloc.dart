import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/shopping-lists/data/shopping_list_service.dart';
import 'package:tcompro_customer/features/shopping-lists/domain/shopping_list.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_event.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_state.dart';

class ShoppingListsBloc extends Bloc<ShoppingListsEvent, ShoppingListsState> {
  final ShoppingListService service;

  ShoppingListsBloc({required this.service})
      : super(ShoppingListsState.initial()) {
    on<LoadShoppingListsEvent>(_onLoadShoppingLists);
    on<CreateShoppingListEvent>(_onCreateShoppingList);
    on<SearchShoppingListsEvent>(_searchShoppingLists);
  }

  Future<void> _onLoadShoppingLists(
      LoadShoppingListsEvent event, Emitter<ShoppingListsState> emit) async {
    try {
      emit(state.copyWith(loading: true, customerId: event.customerId));
      
      final lists = await service.fetchShoppingLists(customerId: event.customerId);
      
      emit(state.copyWith(shoppingLists: lists, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _searchShoppingLists(
      SearchShoppingListsEvent event, Emitter<ShoppingListsState> emit) async {
    final customerId = state.customerId;
    if (customerId == null) return; // Protección si no se ha cargado usuario

    try {
      emit(state.copyWith(loading: true));
      final lists = await service.fetchShoppingLists(
        customerId: customerId,
        name: event.name.isEmpty ? null : event.name,
      );
      emit(state.copyWith(shoppingLists: lists, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onCreateShoppingList(
      CreateShoppingListEvent event, Emitter<ShoppingListsState> emit) async {
    final customerId = state.customerId;
    if (customerId == null) return;

    try {
      emit(state.copyWith(loading: true));
      final newList = await service.addShoppingList(
        customerId,
        event.name,
      );
      final updatedLists = List<ShoppingList>.from(state.shoppingLists)..add(newList);
      emit(state.copyWith(shoppingLists: updatedLists, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}