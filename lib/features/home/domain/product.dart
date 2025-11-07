import 'package:tcompro_customer/features/home/domain/category.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final CategoryType category;
  final double price;
  final String imageUrl = "https://ho.com.uy/wp-content/uploads/2024/09/placeholder-292-1024x683.png";

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: CategoryType.values.byName(json['category']),
      price: json['price'].toDouble()
    );
  }
}