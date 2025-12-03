import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

class ShoppingListItem {
  final int id;
  final int catalogProductId;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String imageUrl;

  ShoppingListItem({
    required this.id,
    required this.catalogProductId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  // Henry you terrorist, whats the point of not creating two
  // classes that differ only by a single field?
  Product get toProduct => Product(
    id: catalogProductId,
    name: name,
    description: description,
    category: CategoryType.ALL,
    price: price,
    imageUrl: imageUrl,
  );

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) => ShoppingListItem(
        id: json['id'],
        catalogProductId: json['catalogProductId'],
        name: json['name'],
        description: json['description'],
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'],
        imageUrl: json['imageUrl'],
      );
}
