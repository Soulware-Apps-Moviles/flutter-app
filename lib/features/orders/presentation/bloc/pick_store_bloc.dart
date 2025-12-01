import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/orders/domain/store.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_store_event.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_store_state.dart';

class PickStoreBloc extends Bloc<PickStoreEvent, PickStoreState> {
  
  PickStoreBloc() : super(PickStoreState()) {
    on<LoadStoresEvent>(_onLoadStores);
    on<SelectStoreEvent>(_onSelectStore);
  }

  FutureOr<void> _onLoadStores(
    LoadStoresEvent event,
    Emitter<PickStoreState> emit,
  ) async {
    emit(state.copyWith(status: PickStoreStatus.loading));
    
    // Mocking data fetch delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      final mockStores = [
        Store(
          id: 1, 
          name: "T'Compro Main Store", 
          address: "Av. Larco 123, Miraflores",
          latitude: -12.119,
          longitude: -77.029,
          imageUrl: "https://via.placeholder.com/150",
        ),
        Store(
          id: 2, 
          name: "T'Compro Express", 
          address: "Jr. De la Unión 456, Lima",
          latitude: -12.046,
          longitude: -77.030,
          imageUrl: "https://via.placeholder.com/150",
        ),
      ];

      emit(state.copyWith(
        status: PickStoreStatus.loaded,
        stores: mockStores,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PickStoreStatus.error,
        errorMessage: "Failed to load stores",
      ));
    }
  }

  FutureOr<void> _onSelectStore(
    SelectStoreEvent event,
    Emitter<PickStoreState> emit,
  ) {
    emit(state.copyWith(selectedStore: event.store));
  }
}