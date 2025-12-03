import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/orders/domain/order_repository.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_shop_event.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_shop_state.dart';

class PickShopBloc extends Bloc<PickShopEvent, PickShopState> {
  final OrderRepository _orderRepository;
  
  PickShopBloc({
    required OrderRepository orderRepository,
  }) : _orderRepository = orderRepository,
       super(PickShopState()) {
    on<LoadShopEvent>(_onLoadStores);
    on<SelectShopEvent>(_onSelectStore);
  }

  FutureOr<void> _onLoadStores(
    LoadShopEvent event,
    Emitter<PickShopState> emit,
  ) async {
    emit(state.copyWith(status: PickShopStatus.loading));

    try {
      final shops = await _orderRepository.findNearbyShops(event.shoppingBag);

      emit(state.copyWith(
        status: PickShopStatus.loaded,
        shops: shops,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PickShopStatus.error,
        errorMessage: "Failed to load stores: $e",
      ));
    }
  }

  FutureOr<void> _onSelectStore(
    SelectShopEvent event,
    Emitter<PickShopState> emit,
  ) {
    emit(state.copyWith(selectedStore: event.shop));
  }
}