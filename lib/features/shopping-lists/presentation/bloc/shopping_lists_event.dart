abstract class ShoppingListsEvent {}

class LoadShoppingListsEvent extends ShoppingListsEvent {
  final int customerId;
  LoadShoppingListsEvent({required this.customerId});
}

class SearchShoppingListsEvent extends ShoppingListsEvent {
  final String name;
  SearchShoppingListsEvent({required this.name});
}

class CreateShoppingListEvent extends ShoppingListsEvent {
  final String name;
  CreateShoppingListEvent({required this.name});
}