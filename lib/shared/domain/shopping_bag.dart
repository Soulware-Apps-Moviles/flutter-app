import 'package:tcompro_customer/shared/domain/bag_item.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

class ShoppingBag {
  final List<BagItem> _items;

  ShoppingBag() : _items = [];

  ShoppingBag.fromItems(List<BagItem> items) : _items = List.from(items);

  List<BagItem> get items => List.unmodifiable(_items);

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.subtotal);
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void increment(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].increment();
    } else {
      _items.add(BagItem(product: product));
    }
  }

  void decrement(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].decrement();
      } else {
        _items.removeAt(index);
      }
    }
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  void clear() {
    _items.clear();
  }
  
  bool contains(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }
}