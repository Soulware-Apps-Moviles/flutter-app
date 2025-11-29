import 'package:tcompro_customer/features/home/domain/category.dart';

abstract class HomeEvent {
  final CategoryType category;
  HomeEvent({required this.category});
}

class LoadProductsEvent extends HomeEvent {
  final int customerId;
  LoadProductsEvent({required this.customerId, required super.category});
}

class CategoryChanged extends HomeEvent {
  CategoryChanged({required super.category});
}

class SearchQuerySent extends HomeEvent {
  final String query;
  SearchQuerySent({required this.query, required super.category});
}