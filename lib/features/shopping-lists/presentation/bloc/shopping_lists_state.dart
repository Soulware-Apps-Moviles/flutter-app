import 'package:tcompro_customer/features/shopping-lists/domain/shopping_list.dart';

class ShoppingListsState {
  final bool loading;
  final List<ShoppingList> shoppingLists;
  final int? customerId;
  final String? error;

  const ShoppingListsState({
    this.loading = false,
    this.shoppingLists = const [],
    this.customerId,
    this.error,
  });

  factory ShoppingListsState.initial() => const ShoppingListsState();

  ShoppingListsState copyWith({
    bool? loading,
    List<ShoppingList>? shoppingLists,
    int? customerId,
    String? error,
  }) {
    return ShoppingListsState(
      loading: loading ?? this.loading,
      shoppingLists: shoppingLists ?? this.shoppingLists,
      customerId: customerId ?? this.customerId,
      error: error ?? this.error, 
    );
  }
}