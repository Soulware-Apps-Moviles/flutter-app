import 'package:tcompro_customer/features/shopping-lists/domain/shopping_list.dart';

class ShoppingListsState {
  final List<ShoppingList> shoppingLists;
  final bool loading;
  final String? error;

  const ShoppingListsState({
    required this.shoppingLists,
    this.loading = false,
    this.error,
  });

  ShoppingListsState copyWith({
    List<ShoppingList>? shoppingLists,
    bool? loading,
    String? error,
  }) {
    return ShoppingListsState(
      shoppingLists: shoppingLists ?? this.shoppingLists,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  factory ShoppingListsState.initial() {
    return ShoppingListsState(shoppingLists: []);
  }
}