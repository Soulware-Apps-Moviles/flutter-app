import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

enum OrderReviewStatus { initial, loading, loaded, error }

class OrderReviewState {
  final OrderReviewStatus status;
  final Shop? shop;
  final ShoppingBag? shoppingBag;
  final String? errorMessage;

  OrderReviewState({
    this.status = OrderReviewStatus.initial,
    this.shop,
    this.shoppingBag,
    this.errorMessage,
  });

  OrderReviewState copyWith({
    OrderReviewStatus? status,
    Shop? shop,
    ShoppingBag? shoppingBag,
    String? errorMessage,
  }) {
    return OrderReviewState(
      status: status ?? this.status,
      shop: shop ?? this.shop,
      shoppingBag: shoppingBag ?? this.shoppingBag,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}