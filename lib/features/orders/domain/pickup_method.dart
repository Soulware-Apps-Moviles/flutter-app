enum PickupMethod {
  delivery,
  shopPickUp;

  static PickupMethod fromString(String value) {
    switch (value) {
      case 'DELIVERY':
        return PickupMethod.delivery;
      case 'SHOP_PICK_UP':
        return PickupMethod.shopPickUp;
      default:
        throw Exception('Unknown pickup method: $value');
    }
  }

  String get displayName {
    switch (this) {
      case PickupMethod.delivery:
        return 'Delivery';
      case PickupMethod.shopPickUp:
        return 'Shop Pickup';
    }
  }
}