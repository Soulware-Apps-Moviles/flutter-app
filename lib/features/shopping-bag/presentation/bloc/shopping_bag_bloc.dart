import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/core/data/cubits/profile_cubit.dart';
import 'package:tcompro_customer/features/shopping-bag/presentation/bloc/shopping_bag_event.dart';
import 'package:tcompro_customer/features/shopping-bag/presentation/bloc/shopping_bag_state.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';
import 'package:tcompro_customer/shared/domain/profile.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

class ShoppingBagBloc extends Bloc<ShoppingBagEvent, ShoppingBagState> {
  final ProductRepository _productRepository;
  final ProfileCubit _profileCubit;
  late final StreamSubscription<Profile?> _profileSubscription;
  // ignore: unused_field
  late final StreamSubscription _bagSubscription;

  int? _currentCustomerId;

  ShoppingBagBloc({
    required ProductRepository productRepository,
    required ProfileCubit profileCubit,
  })  : _productRepository = productRepository,
        _profileCubit = profileCubit,
        super(ShoppingBagState.initial()) {
    on<LoadShoppingBag>(_onLoadShoppingBag);
    on<IncrementItemQuantity>(_onIncrementItem);
    on<DecrementItemQuantity>(_onDecrementItem);
    on<RemoveItemFromBag>(_onRemoveItem);
    on<ClearShoppingBag>(_onClearBag);

    _setupProfileListener();
    _setupBagListener();

    add(LoadShoppingBag());
  }

  void _setupProfileListener() {
    if (_profileCubit.state != null) {
      _currentCustomerId = _profileCubit.state!.id;
    }

    _profileSubscription = _profileCubit.stream.listen((profile) {
      final newId = profile?.id;
      if (_currentCustomerId != newId) {
        _currentCustomerId = newId;
        add(LoadShoppingBag());
      }
    });
  }

  void _setupBagListener() {
    _bagSubscription = _productRepository.bagUpdates.listen((_) {
      add(LoadShoppingBag());
    });
  }

  @override
  Future<void> close() {
    _profileSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onLoadShoppingBag(
    LoadShoppingBag event,
    Emitter<ShoppingBagState> emit,
  ) async {
    emit(state.copyWith(status: ShoppingBagStatus.loading));
    try {
      final items = await _productRepository.getShoppingBagItems();
      emit(state.copyWith(
        status: ShoppingBagStatus.loaded,
        bag: ShoppingBag.fromItems(items),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ShoppingBagStatus.error,
        errorMessage: "Error loading shopping bag: $e",
      ));
    }
  }

  FutureOr<void> _onIncrementItem(
    IncrementItemQuantity event,
    Emitter<ShoppingBagState> emit,
  ) async {
    final tempBag = ShoppingBag.fromItems(state.bag.items);
    tempBag.increment(event.product);

    try {
      await _productRepository.addOneToShoppingBag(
        customerId: _currentCustomerId ?? 0,
        product: event.product,
      );
      add(LoadShoppingBag());
    } catch (e) {
      emit(state.copyWith(
        status: ShoppingBagStatus.error,
        errorMessage: "Error adding product to bag: $e",
      ));
    }
  }

  FutureOr<void> _onDecrementItem(
  DecrementItemQuantity event,
  Emitter<ShoppingBagState> emit,
) async {
  try {
    await _productRepository.decreaseQuantity(
      customerId: _currentCustomerId ?? 0,
      product: event.product,
    );

    add(LoadShoppingBag());
  } catch (e) {
    emit(state.copyWith(errorMessage: e.toString()));
  }
}

  FutureOr<void> _onRemoveItem(
    RemoveItemFromBag event,
    Emitter<ShoppingBagState> emit,
  ) async {
    final tempBag = ShoppingBag.fromItems(state.bag.items);
    tempBag.remove(event.product);

    try {
      await _productRepository.removeFromShoppingBag(
        customerId: _currentCustomerId ?? 0,
        product: event.product,
      );
      add(LoadShoppingBag());
    } catch (e) {
      emit(state.copyWith(
        status: ShoppingBagStatus.error,
        errorMessage: "Error removing product from bag: $e",
      ));
    }
  }

  FutureOr<void> _onClearBag(
    ClearShoppingBag event,
    Emitter<ShoppingBagState> emit,
  ) async {
    final tempBag = ShoppingBag.fromItems(state.bag.items);
    tempBag.clear();

    try {
      await _productRepository.clearShoppingBag(
        customerId: _currentCustomerId ?? 0,
      );
      emit(state.copyWith(
        status: ShoppingBagStatus.loaded,
        bag: ShoppingBag(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ShoppingBagStatus.error,
        errorMessage: "Error clearing shopping bag: $e",
      ));
    }
  }
}