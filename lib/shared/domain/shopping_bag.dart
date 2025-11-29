
import 'package:tcompro_customer/shared/domain/bag_item.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

class ShoppingBag {
  final List<BagItem> _items = [];

  List<BagItem> get items => List.unmodifiable(_items);

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.subtotal);
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addToBag(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      final index = _items.indexWhere((item) => item.product.id == product.id);
      _items[index].increment();
      return;
    } 

    _items.add(BagItem(product: product));
  }

  void removeFromBag(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items.removeAt(index);
    } 
  }

  void clear() {
    _items.clear();
  }
}