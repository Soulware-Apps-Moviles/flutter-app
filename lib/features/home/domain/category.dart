// ignore_for_file: constant_identifier_names

enum CategoryType {
  ALL('ALL'),
  PRODUCE('PRODUCE'),
  DAIRY('DAIRY'),
  MEAT('MEAT'),
  BEVERAGES('BEVERAGES'),
  HOUSE('HOUSEHOLD'),
  GROCERY('GROCERY'),
  SNACKS('SNACKS'),
  PET('PET PRODUCTS'),
  OTHER('OTHER');

  final String stringName;

  const CategoryType(this.stringName);
}