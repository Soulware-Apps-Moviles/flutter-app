import 'package:tcompro_customer/shared/domain/bag_item.dart';
import 'package:tcompro_customer/shared/domain/product.dart';
import 'package:tcompro_customer/features/home/domain/category.dart';

extension BagItemMapper on BagItem {
  Map<String, dynamic> toLocalDbMap() {
    return {
      'product_id': product.id,
      'name': product.name,
      'price': product.price,
      'image_url': product.imageUrl,
      'description': product.description,
      'category': product.category.stringName,
      'quantity': quantity,
      'is_favorite': product.isFavorite ? 1 : 0,
    };
  }

  static BagItem fromLocalDbMap(Map<String, dynamic> map) {
    return BagItem(
      product: Product(
        id: map['product_id'] as int,
        name: map['name'] as String,
        price: map['price'] as double,
        imageUrl: map['image_url'] as String,
        description: map['description'] as String,
        category: CategoryType.values.firstWhere(
          (e) => e.stringName == map['category'],
          orElse: () => CategoryType.ALL,
        ),
        isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      ),
      quantity: map['quantity'] as int,
    );
  }
}