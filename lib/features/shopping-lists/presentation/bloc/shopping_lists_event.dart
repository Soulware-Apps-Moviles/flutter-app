abstract class ShoppingListsEvent {}

class LoadShoppingListsEvent extends ShoppingListsEvent {
  final int customerId;
  LoadShoppingListsEvent({required this.customerId});
}

class CreateShoppingListEvent extends ShoppingListsEvent {
  final int customerId;
  final String name;
  CreateShoppingListEvent({required this.customerId, required this.name});
}