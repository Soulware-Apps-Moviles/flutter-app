class OrderLine {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final int catalogProductId;
  final String imageUrl;

  OrderLine({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.catalogProductId,
    required this.imageUrl,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      catalogProductId: json['catalogProductId'],
      imageUrl: json['imageUrl'],
    );
  }

  OrderLine copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    int? catalogProductId,
    String? imageUrl,
  }) {
    return OrderLine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      catalogProductId: catalogProductId ?? this.catalogProductId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}