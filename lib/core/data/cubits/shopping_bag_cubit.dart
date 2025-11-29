// Its a bloc-type class that handles the in-memory  of the user's Shopping Bag
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/shared/domain/product.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

class ShoppingBagCubit extends Cubit<ShoppingBag> {
  final ShoppingBag _bag = ShoppingBag();

  ShoppingBagCubit() : super(ShoppingBag());

  double get totalPrice {
    return _bag.totalPrice;
  }

  int get totalItems {
    return _bag.totalItems;
  }

  void addProduct(Product product) {
    _bag.addToBag(product);
    emit(_bag); 
  }

  void removeProduct(Product product) {
    _bag.removeFromBag(product);
    emit(_bag); 
  }

  void clear() {
    _bag.clear();
    emit(_bag); 
  }
}