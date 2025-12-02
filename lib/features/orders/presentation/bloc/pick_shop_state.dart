import 'package:tcompro_customer/features/orders/domain/shop.dart';

enum PickStoreStatus { initial, loading, loaded, error }

class PickShopState {
  final PickStoreStatus status;
  final List<Shop> shops;
  final Shop? selectedStore;
  final String? errorMessage;

  PickShopState({
    this.status = PickStoreStatus.initial,
    this.shops = const [],
    this.selectedStore,
    this.errorMessage,
  });

  PickShopState copyWith({
    PickStoreStatus? status,
    List<Shop>? stores,
    Shop? selectedStore,
    String? errorMessage,
  }) {
    return PickShopState(
      status: status ?? this.status,
      shops: stores ?? this.shops,
      selectedStore: selectedStore ?? this.selectedStore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}