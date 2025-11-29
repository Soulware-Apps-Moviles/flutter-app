import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

enum Status { initial, loading, loaded, error }

class HomeState {
  final Status status;
  final CategoryType selectedCategory;
  final List<Product> products;
  final int? customerId;
  final String? errorMessage;

  const HomeState({
    this.status = Status.initial,
    this.selectedCategory = CategoryType.ALL,
    this.products = const [],
    this.customerId,
    this.errorMessage,
  });

  HomeState copyWith({
    Status? status,
    CategoryType? selectedCategory,
    List<Product>? products,
    int? customerId,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      products: products ?? this.products,
      customerId: customerId ?? this.customerId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}