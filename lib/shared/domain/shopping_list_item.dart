import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

class ShoppingListItem {
  final int id;
  final Product product;
  final int quantity;

  ShoppingListItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  double get subtotal => product.price * quantity;

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    final product = Product(
      id: json['catalogProductId'],
      name: json['name'],
      description: json['description'],
      category: CategoryType.ALL,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
    );

    return ShoppingListItem(
      id: json['id'],
      product: product,
      quantity: json['quantity'],
    );
  }

  ShoppingListItem copyWith({
    int? id,
    Product? product,
    int? quantity,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}