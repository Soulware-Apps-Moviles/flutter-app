import 'package:tcompro_customer/shared/domain/product.dart';

enum FavoritesStatus { initial, loading, loaded, error }

class FavoritesState {
  final FavoritesStatus status;
  final List<Product> products;
  final int? customerId;
  final String? errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.products = const [],
    this.customerId,
    this.errorMessage,
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Product>? products,
    int? customerId,
    String? errorMessage,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      products: products ?? this.products,
      customerId: customerId ?? this.customerId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}