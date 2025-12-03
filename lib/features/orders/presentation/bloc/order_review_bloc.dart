import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/orders/domain/order_repository.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/order_review_event.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/order_review_state.dart';

class OrderReviewBloc extends Bloc<OrderReviewEvent, OrderReviewState> {
  final OrderRepository orderRepository;

  OrderReviewBloc({
    required this.orderRepository,
  }) : super(const OrderReviewState()) {
    on<LoadOrderReviewEvent>(_onLoad);
    on<ChangePaymentMethodEvent>(_onChangePaymentMethod);
    on<ChangePickupMethodEvent>(_onChangePickupMethod);
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  FutureOr<void> _onLoad(
    LoadOrderReviewEvent event,
    Emitter<OrderReviewState> emit,
  ) {
    emit(state.copyWith(status: OrderReviewStatus.loading));

    emit(state.copyWith(
      status: OrderReviewStatus.loaded,
      shop: event.shop,
      shoppingBag: event.shoppingBag,
      customerId: event.customerId,
    ));
  }

  FutureOr<void> _onChangePaymentMethod(
    ChangePaymentMethodEvent event,
    Emitter<OrderReviewState> emit,
  ) {
    emit(state.copyWith(selectedPaymentMethod: event.method));
  }

  FutureOr<void> _onChangePickupMethod(
    ChangePickupMethodEvent event,
    Emitter<OrderReviewState> emit,
  ) {
    emit(state.copyWith(selectedPickupMethod: event.method));
  }

  FutureOr<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<OrderReviewState> emit,
  ) async {
    final currentShop = state.shop;
    final currentBag = state.shoppingBag;
    final customerId = state.customerId;
    final payment = state.selectedPaymentMethod;
    final pickup = state.selectedPickupMethod;

    if (currentShop == null || currentBag == null || customerId == null || payment == null || pickup == null) {
      emit(state.copyWith(
        status: OrderReviewStatus.error,
        errorMessage: "Incomplete information to process the order.",
      ));
      return;
    }

    emit(state.copyWith(status: OrderReviewStatus.submitting));

    try {
      final createdOrder = await orderRepository.createOrder(
        customerId: customerId,
        shopId: currentShop.id,
        items: currentBag.items,
        paymentMethod: payment,
        pickupMethod: pickup,
        totalAmount: currentBag.totalPrice, 
      );

      emit(state.copyWith(
        status: OrderReviewStatus.success,
        createdOrder: createdOrder,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderReviewStatus.error,
        errorMessage: "Error creating order: ${e.toString()}",
      ));
    }
  }
}