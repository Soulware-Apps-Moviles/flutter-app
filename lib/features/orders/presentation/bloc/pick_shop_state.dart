import 'package:tcompro_customer/features/orders/domain/shop.dart';

enum PickShopStatus { initial, loading, loaded, error }

class PickShopState {
  final PickShopStatus status;
  final List<Shop> shops;
  final Shop? selectedStore;
  final String? errorMessage;

  PickShopState({
    this.status = PickShopStatus.initial,
    this.shops = const [],
    this.selectedStore,
    this.errorMessage,
  });

  PickShopState copyWith({
    PickShopStatus? status,
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