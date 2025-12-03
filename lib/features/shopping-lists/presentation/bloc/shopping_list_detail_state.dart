import 'package:tcompro_customer/shared/domain/shopping_list.dart';

enum ShoppingListDetailStatus { initial, loading, loaded, error }

class ShoppingListDetailState {
  final ShoppingListDetailStatus status;
  final ShoppingList? list;
  final int? customerId;
  final String? errorMessage;
  final String? actionMessage; 

  const ShoppingListDetailState({
    this.status = ShoppingListDetailStatus.initial,
    this.list,
    this.customerId,
    this.errorMessage,
    this.actionMessage,
  });

  ShoppingListDetailState copyWith({
    ShoppingListDetailStatus? status,
    ShoppingList? list,
    int? customerId,
    String? errorMessage,
    String? actionMessage,
  }) {
    return ShoppingListDetailState(
      status: status ?? this.status,
      list: list ?? this.list,
      customerId: customerId ?? this.customerId,
      errorMessage: errorMessage ?? this.errorMessage,
      actionMessage: actionMessage,
    );
  }
}