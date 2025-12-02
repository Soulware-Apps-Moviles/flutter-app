import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/order_review_event.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/order_review_state.dart';

class OrderReviewBloc extends Bloc<OrderReviewEvent, OrderReviewState> {
  OrderReviewBloc() : super(OrderReviewState()) {
    on<LoadOrderReviewEvent>(_onLoadOrderReview);
  }

  FutureOr<void> _onLoadOrderReview(
    LoadOrderReviewEvent event,
    Emitter<OrderReviewState> emit,
  ) {
    emit(state.copyWith(status: OrderReviewStatus.loading));
    
    try {
      emit(state.copyWith(
        status: OrderReviewStatus.loaded,
        shop: event.shop,
        shoppingBag: event.shoppingBag,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderReviewStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}