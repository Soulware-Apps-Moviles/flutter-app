class ShoppingItem {
  final int id;
  final int catalogProductId;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String imageUrl;

  ShoppingItem({
    required this.id,
    required this.catalogProductId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
        id: json['id'],
        catalogProductId: json['catalogProductId'],
        name: json['name'],
        description: json['description'],
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'],
        imageUrl: json['imageUrl'],
      );
}
