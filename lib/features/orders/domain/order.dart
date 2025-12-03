import 'package:tcompro_customer/features/orders/domain/order_line.dart';

class Order {
  final int id;
  final List<OrderLine> orderlines;
  final int customerId;
  final int shopId;
  final String paymentMethod;
  final String pickupMethod;
  final String status;

  Order({
    required this.id,
    required this.orderlines,
    required this.customerId,
    required this.shopId,
    required this.paymentMethod,
    required this.pickupMethod,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderlines: (json['orderlines'] as List)
          .map((e) => OrderLine.fromJson(e))
          .toList(),
      customerId: json['customerId'],
      shopId: json['shopId'],
      paymentMethod: json['paymentMethod'],
      pickupMethod: json['pickupMethod'],
      status: json['status'],
    );
  }

  Order copyWith({
    int? id,
    List<OrderLine>? orderlines,
    int? customerId,
    int? shopId,
    String? paymentMethod,
    String? pickupMethod,
    String? status,
  }) {
    return Order(
      id: id ?? this.id,
      orderlines: orderlines ?? this.orderlines,
      customerId: customerId ?? this.customerId,
      shopId: shopId ?? this.shopId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      pickupMethod: pickupMethod ?? this.pickupMethod,
      status: status ?? this.status,
    );
  }
}