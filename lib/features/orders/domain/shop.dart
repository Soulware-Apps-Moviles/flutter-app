class Shop {
  final int id;
  final int ownerId;
  final List<String> paymentMethods;
  final List<String> pickupMethods;
  final double maxCreditPerCustomer;
  final double latitude;
  final double longitude;
  final String name;

  Shop({
    required this.id,
    required this.ownerId,
    required this.paymentMethods,
    required this.pickupMethods,
    required this.maxCreditPerCustomer,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      ownerId: json['ownerId'],
      paymentMethods: List<String>.from(json['paymentMethods']),
      pickupMethods: List<String>.from(json['pickupMethods']),
      maxCreditPerCustomer: json['maxCreditPerCustomer'].toDouble(),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      name: json['name'],
    );
  }

  Shop copyWith({
    int? id,
    int? ownerId,
    List<String>? paymentMethods,
    List<String>? pickupMethods,
    double? maxCreditPerCustomer,
    double? latitude,
    double? longitude,
    String? name,
  }) {
    return Shop(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      pickupMethods: pickupMethods ?? this.pickupMethods,
      maxCreditPerCustomer: maxCreditPerCustomer ?? this.maxCreditPerCustomer,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
    );
  }
}