import 'package:tcompro_customer/shared/domain/product.dart';

class BagItem {
  final Product product;
  int quantity;

  BagItem({
    required this.product,
    this.quantity = 1,
  });

  double get subtotal => product.price * quantity;

  void increment() {
    quantity += 1;
  }

  void decrement() {
    if (quantity > 1) quantity -= 1;
  }
}