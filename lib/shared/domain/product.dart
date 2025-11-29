import 'package:tcompro_customer/features/home/domain/category.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final CategoryType category;
  final double price;
  final String imageUrl;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: CategoryType.values.byName(json['category']),
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      isFavorite: false // Product service never returns the isFavorite
    );
  }

  Product copyWith({
    int? id,
    String? name,
    String? description,
    CategoryType? category,
    double? price,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}