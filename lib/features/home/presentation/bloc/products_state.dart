import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/features/home/domain/product.dart';

enum Status { initial, loading, loaded, error }

class ProductsState {
  final Status status;
  final CategoryType selectedCategory;
  final List<Product> products;
  final String? errorMessage;

  const ProductsState({
    this.status = Status.initial,
    this.selectedCategory = CategoryType.ALL,
    this.products = const [],
    this.errorMessage,
  });

  ProductsState copyWith({
    Status? status,
    CategoryType? selectedCategory,
    List<Product>? products,
    String? errorMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}