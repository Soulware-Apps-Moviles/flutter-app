abstract class ShoppingListsEvent {}

class LoadShoppingListsEvent extends ShoppingListsEvent {}

class CreateShoppingListEvent extends ShoppingListsEvent {
  final int customerId;
  final String name;
  CreateShoppingListEvent({required this.customerId, required this.name});
}