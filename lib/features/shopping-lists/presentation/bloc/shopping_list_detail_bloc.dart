import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_list_detail_event.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_list_detail_state.dart';
import 'package:tcompro_customer/shared/domain/shopping_list.dart';
import 'package:tcompro_customer/shared/domain/shopping_list_repository.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';

class ShoppingListDetailBloc extends Bloc<ShoppingListDetailEvent, ShoppingListDetailState> {
  final ShoppingListRepository shoppingListRepository;
  final ProductRepository productRepository;
  late StreamSubscription<ShoppingList> _listSubscription;

  ShoppingListDetailBloc({
    required this.shoppingListRepository,
    required this.productRepository,
  }) : super(const ShoppingListDetailState()) {
    on<LoadShoppingListDetail>(_onLoadShoppingListDetail);
    on<ShoppingListReceived>(_onShoppingListReceived);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<AddItemToBag>(_onAddItemToBag);
    on<AddListToBag>(_onAddListToBag);
  }

  @override
  Future<void> close() {
    _listSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onLoadShoppingListDetail(
    LoadShoppingListDetail event,
    Emitter<ShoppingListDetailState> emit,
  ) async {
    emit(state.copyWith(
      status: ShoppingListDetailStatus.loaded,
      list: event.initialList,
      customerId: event.customerId,
    ));

    final targetListId = event.initialList.id;

    _listSubscription = shoppingListRepository.listUpdates.listen((updatedList) {
      if (updatedList.id == targetListId) {
        add(ShoppingListReceived(list: updatedList));
      }
    });
  }

  FutureOr<void> _onShoppingListReceived(
    ShoppingListReceived event,
    Emitter<ShoppingListDetailState> emit,
  ) {
    emit(state.copyWith(
      list: event.list,
      status: ShoppingListDetailStatus.loaded,
    ));
  }

  FutureOr<void> _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<ShoppingListDetailState> emit,
  ) async {
    final currentList = state.list;
    if (currentList == null) return;

    try {
      await shoppingListRepository.addItemOrUpdateQuantity(
        list: currentList,
        product: event.item.toProduct,
        newQuantity: event.newQuantity,
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: "Error updating quantity: ${e.toString()}"));
    }
  }

  FutureOr<void> _onAddItemToBag(
    AddItemToBag event,
    Emitter<ShoppingListDetailState> emit,
  ) async {
    final customerId = state.customerId;
    if (customerId == null) return;

    try {
      await productRepository.addManyToShoppingBag(
        customerId: customerId,
        product: event.item.toProduct,
        quantity: event.item.quantity,
      );
      
      emit(state.copyWith(
        actionMessage: "Added ${event.item.quantity} x ${event.item.name} to Main Bag",
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: "Failed to add to bag: ${e.toString()}"));
    }
  }

  FutureOr<void> _onAddListToBag(
    AddListToBag event,
    Emitter<ShoppingListDetailState> emit,
  ) async {
    final customerId = state.customerId;
    final currentList = state.list;
    if (customerId == null || currentList == null) return;

    try {
      await Future.wait(currentList.items.map((item) {
        return productRepository.addManyToShoppingBag(
          customerId: customerId,
          product: item.toProduct,
          quantity: item.quantity,
        );
      }));
      
      emit(state.copyWith(actionMessage: "All items added to bag"));
    } catch (e) {
      emit(state.copyWith(errorMessage: "Failed to add list to bag: ${e.toString()}"));
    }
  }
}