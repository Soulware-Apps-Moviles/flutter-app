import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final String productsEndpoint = dotenv.env['PRODUCTS_ENDPOINT'] ?? '';
  static final String favoritesEndpoint = dotenv.env['FAVORITES_ENDPOINT'] ?? '';
  static final String shoppingListsEndpoint = dotenv.env['SHOPPING_LISTS_ENDPOINT'] ?? '';
}
