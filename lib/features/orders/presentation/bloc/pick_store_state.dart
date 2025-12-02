import 'package:tcompro_customer/features/orders/domain/shop.dart';

enum PickStoreStatus { initial, loading, loaded, error }

class PickStoreState {
  final PickStoreStatus status;
  final List<Shop> stores;
  final Shop? selectedStore;
  final String? errorMessage;

  PickStoreState({
    this.status = PickStoreStatus.initial,
    this.stores = const [],
    this.selectedStore,
    this.errorMessage,
  });

  PickStoreState copyWith({
    PickStoreStatus? status,
    List<Shop>? stores,
    Shop? selectedStore,
    String? errorMessage,
  }) {
    return PickStoreState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      selectedStore: selectedStore ?? this.selectedStore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}