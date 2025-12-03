import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

enum ShoppingBagStatus { initial, loading, loaded, error }

class ShoppingBagState {
  final ShoppingBagStatus status;
  final ShoppingBag bag;
  final String? errorMessage;

  const ShoppingBagState({
    this.status = ShoppingBagStatus.initial,
    required this.bag,
    this.errorMessage,
  });

  factory ShoppingBagState.initial() => ShoppingBagState(bag: ShoppingBag());

  ShoppingBagState copyWith({
    ShoppingBagStatus? status,
    ShoppingBag? bag,
    String? errorMessage,
  }) {
    return ShoppingBagState(
      status: status ?? this.status,
      bag: bag ?? this.bag,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}