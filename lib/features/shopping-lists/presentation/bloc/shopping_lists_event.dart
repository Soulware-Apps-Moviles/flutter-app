abstract class ShoppingListsEvent {}

class LoadShoppingListsEvent extends ShoppingListsEvent {}

class SearchShoppingListsEvent extends ShoppingListsEvent {
  final String name;
  SearchShoppingListsEvent({required this.name});
}

class CreateShoppingListEvent extends ShoppingListsEvent {
  final int customerId;
  final String name;
  CreateShoppingListEvent({required this.customerId, required this.name});
}