import 'package:tcompro_customer/features/orders/domain/store.dart';

abstract class PickStoreEvent {}

class LoadStoresEvent extends PickStoreEvent {}

class SelectStoreEvent extends PickStoreEvent {
  final Store store;
  SelectStoreEvent({required this.store});
}