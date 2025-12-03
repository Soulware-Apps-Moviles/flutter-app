import 'package:tcompro_customer/shared/domain/shopping_list_item.dart';
import 'package:tcompro_customer/shared/domain/shopping_list.dart';

abstract class ShoppingListDetailEvent {}

class LoadShoppingListDetail extends ShoppingListDetailEvent {
  final ShoppingList initialList;
  final int customerId;
  LoadShoppingListDetail({required this.initialList, required this.customerId});
}

class ShoppingListReceived extends ShoppingListDetailEvent {
  final ShoppingList list;
  ShoppingListReceived({required this.list});
}

class UpdateItemQuantity extends ShoppingListDetailEvent {
  final ShoppingItem item;
  final int newQuantity;
  UpdateItemQuantity({required this.item, required this.newQuantity});
}

class AddItemToBag extends ShoppingListDetailEvent {
  final ShoppingItem item;
  AddItemToBag({required this.item});
}

class AddListToBag extends ShoppingListDetailEvent {
  AddListToBag();
}