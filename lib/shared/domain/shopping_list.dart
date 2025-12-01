import 'package:tcompro_customer/shared/domain/shopping_list_item.dart';

class ShoppingList {
  final int id;
  final int customerId;
  final String name;
  final List<ShoppingItem> items;

  ShoppingList({
    required this.id,
    required this.customerId,
    required this.name,
    required this.items,
  });

  factory ShoppingList.fromJson(Map<String, dynamic> json) => ShoppingList(
        id: json['id'],
        customerId: json['customerId'],
        name: json['name'],
        items: (json['items'] as List)
            .map((i) => ShoppingItem.fromJson(i))
            .toList(),
      );
}