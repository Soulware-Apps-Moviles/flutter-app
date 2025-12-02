import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/orders/domain/order_repository.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_store_event.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_store_state.dart';

class PickStoreBloc extends Bloc<PickStoreEvent, PickStoreState> {
  final OrderRepository _orderRepository;
  
  PickStoreBloc({
    required OrderRepository orderRepository,
  }) : _orderRepository = orderRepository,
       super(PickStoreState()) {
    on<LoadStoresEvent>(_onLoadStores);
    on<SelectShopEvent>(_onSelectStore);
  }

  FutureOr<void> _onLoadStores(
    LoadStoresEvent event,
    Emitter<PickStoreState> emit,
  ) async {
    emit(state.copyWith(status: PickStoreStatus.loading));

    try {
      final shops = await _orderRepository.findNearbyShops(event.shoppingBag);

      emit(state.copyWith(
        status: PickStoreStatus.loaded,
        stores: shops,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PickStoreStatus.error,
        errorMessage: "Failed to load stores: $e",
      ));
    }
  }

  FutureOr<void> _onSelectStore(
    SelectShopEvent event,
    Emitter<PickStoreState> emit,
  ) {
    emit(state.copyWith(selectedStore: event.shop));
  }
}