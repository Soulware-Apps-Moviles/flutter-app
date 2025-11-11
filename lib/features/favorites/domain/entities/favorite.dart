class Favorite {
  final int id;
  final int productId;
  final int customerId;

  Favorite({
    required this.id,
    required this.productId,
    required this.customerId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      productId: json['catalogProductId'],
      customerId: json['customerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'catalogProductId': productId,
      'customerId': customerId,
    };
  }
}