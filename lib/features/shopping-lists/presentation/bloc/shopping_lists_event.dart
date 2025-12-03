import 'package:tcompro_customer/shared/domain/shopping_list.dart';
import 'package:tcompro_customer/shared/domain/shopping_list_item.dart';

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

class ShoppingListUpdatedFromStream extends ShoppingListsEvent {
  final ShoppingList list;
  ShoppingListUpdatedFromStream({required this.list});
}

class AddListToBagEvent extends ShoppingListsEvent {
  final ShoppingList list;
  AddListToBagEvent({required this.list});
}

class UpdateItemQuantityEvent extends ShoppingListsEvent {
  final ShoppingList list;
  final ShoppingItem item;
  final int newQuantity;

  UpdateItemQuantityEvent({
    required this.list,
    required this.item,
    required this.newQuantity,
  });
}

class RemoveItemFromListEvent extends ShoppingListsEvent {
  final ShoppingList list;
  final ShoppingItem item;

  RemoveItemFromListEvent({
    required this.list,
    required this.item,
  });
}