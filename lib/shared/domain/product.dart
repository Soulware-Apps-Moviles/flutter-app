import 'package:tcompro_customer/features/home/domain/category.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final CategoryType category;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: CategoryType.values.byName(json['category']),
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
}