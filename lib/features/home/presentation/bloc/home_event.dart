import 'package:tcompro_customer/features/home/domain/category.dart';

abstract class HomeEvent {}

class LoadProductsEvent extends HomeEvent {
  final CategoryType category;
  LoadProductsEvent({required this.category});
}

class SearchProductsEvent extends HomeEvent {
  final String name;
  final String category;
  SearchProductsEvent({
    required this.name, 
    required this.category
    });
}