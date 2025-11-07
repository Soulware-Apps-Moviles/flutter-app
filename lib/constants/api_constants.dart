class ApiConstants {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final String productsEndpoint = dotenv.env['PRODUCTS_ENDPOINT'] ?? '';
}