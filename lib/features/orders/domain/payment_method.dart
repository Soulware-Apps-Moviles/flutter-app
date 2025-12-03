enum PaymentMethod {
  cash,
  onCredit,
  virtual;

  static PaymentMethod fromString(String value) {
    switch (value) {
      case 'CASH':
        return PaymentMethod.cash;
      case 'ON_CREDIT':
        return PaymentMethod.onCredit;
      case 'VIRTUAL':
        return PaymentMethod.virtual;
      default:
        throw Exception('Unknown payment method: $value');
    }
  }

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.onCredit:
        return 'Credit';
      case PaymentMethod.virtual:
        return 'Virtual';
    }
  }
}