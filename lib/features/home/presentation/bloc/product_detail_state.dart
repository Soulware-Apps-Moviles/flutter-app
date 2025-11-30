import 'package:tcompro_customer/shared/domain/product.dart';

enum ProductDetailStatus { initial, loading, loaded, error }

class ProductDetailState {
  final ProductDetailStatus status;
  final Product? product;
  final List<Product> relatedProducts;
  final int? customerId;
  final String? errorMessage;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.relatedProducts = const [],
    this.customerId,
    this.errorMessage,
  });

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    Product? product,
    List<Product>? relatedProducts,
    int? customerId,
    String? errorMessage,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      customerId: customerId ?? this.customerId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}