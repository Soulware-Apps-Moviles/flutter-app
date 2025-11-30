import 'package:sqflite/sqflite.dart';
import 'package:tcompro_customer/core/database/app_database.dart';
import 'package:tcompro_customer/shared/data/local/shopping_bag_mapper.dart';
import 'package:tcompro_customer/shared/domain/bag_item.dart';

class ShoppingBagDao {
  
  Future<List<BagItem>> fetchBagItems() async {
    final Database database = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await database.query('cart_items');

    return maps.map((map) => BagItemMapper.fromLocalDbMap(map)).toList();
  }

  Future<void> insertOrUpdate(BagItem item) async {
    final Database database = await AppDatabase().database;
    await database.insert(
      'cart_items',
      item.toLocalDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateQuantity(int productId, int newQuantity) async {
    final Database database = await AppDatabase().database;
    await database.update(
      'cart_items',
      {'quantity': newQuantity},
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> updateFavoriteStatus(int productId, bool isFavorite) async {
    final Database database = await AppDatabase().database;
    await database.update(
      'cart_items',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> delete(int productId) async {
    final Database database = await AppDatabase().database;
    await database.delete(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> clearAll() async {
    final Database database = await AppDatabase().database;
    await database.delete('cart_items');
  }
}