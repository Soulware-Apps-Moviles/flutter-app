import 'package:tcompro_customer/features/orders/domain/order.dart';
import 'package:tcompro_customer/features/orders/domain/payment_method.dart';
import 'package:tcompro_customer/features/orders/domain/pickup_method.dart';
import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

enum OrderReviewStatus { initial, loading, loaded, submitting, success, error }

class OrderReviewState {
  final OrderReviewStatus status;
  final Shop? shop;
  final ShoppingBag? shoppingBag;
  final int? customerId;
  final PaymentMethod? selectedPaymentMethod;
  final PickupMethod? selectedPickupMethod;
  final Order? createdOrder;
  final String? errorMessage;

  const OrderReviewState({
    this.status = OrderReviewStatus.initial,
    this.shop,
    this.shoppingBag,
    this.customerId,
    this.selectedPaymentMethod,
    this.selectedPickupMethod,
    this.createdOrder,
    this.errorMessage,
  });

  OrderReviewState copyWith({
    OrderReviewStatus? status,
    Shop? shop,
    ShoppingBag? shoppingBag,
    int? customerId,
    PaymentMethod? selectedPaymentMethod,
    PickupMethod? selectedPickupMethod,
    Order? createdOrder,
    String? errorMessage,
  }) {
    return OrderReviewState(
      status: status ?? this.status,
      shop: shop ?? this.shop,
      shoppingBag: shoppingBag ?? this.shoppingBag,
      customerId: customerId ?? this.customerId,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedPickupMethod: selectedPickupMethod ?? this.selectedPickupMethod,
      createdOrder: createdOrder ?? this.createdOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}