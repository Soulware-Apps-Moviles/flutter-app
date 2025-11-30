import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

abstract class HomeEvent {}

class LoadProductsEvent extends HomeEvent {
  final int customerId;
  final CategoryType category;
  LoadProductsEvent({required this.customerId, required this.category});
}

class CategoryChanged extends HomeEvent {
  final CategoryType category;
  CategoryChanged({required this.category});
}

class SearchQuerySent extends HomeEvent {
  final String query;
  final CategoryType category;
  SearchQuerySent({required this.query, required this.category});
}

class ToggleFavorite extends HomeEvent {
  final Product product;
  ToggleFavorite({required this.product}) : super();
}

class AddToShoppingBag extends HomeEvent {
  final Product product;
  AddToShoppingBag({required this.product}) : super();
}