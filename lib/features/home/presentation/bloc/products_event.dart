import 'package:tcompro_customer/features/home/domain/category.dart';

abstract class ProductsEvent {}

class LoadProductsEvent extends ProductsEvent {
  final CategoryType category;
  LoadProductsEvent({required this.category});
}

class SearchProductsEvent extends ProductsEvent {
  final String name;
  final String category;
  SearchProductsEvent({
    required this.name, 
    required this.category
    });
}