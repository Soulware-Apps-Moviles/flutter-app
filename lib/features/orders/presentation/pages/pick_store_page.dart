import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/orders/domain/order_repository.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_store_bloc.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_store_event.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_store_state.dart';
import 'package:tcompro_customer/features/orders/presentation/widgets/ShopCard.dart';
import 'package:tcompro_customer/features/orders/presentation/widgets/bottom_shop_selection_bar.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

class PickStorePage extends StatelessWidget {
  final ShoppingBag shoppingBag;

  const PickStorePage({
    super.key,
    required this.shoppingBag,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PickStoreBloc(
        orderRepository: context.read<OrderRepository>(),
      )..add(LoadStoresEvent(shoppingBag)),
      child: const _PickStoreView(),
    );
  }
}

class _PickStoreView extends StatelessWidget {
  const _PickStoreView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Store"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<PickStoreBloc, PickStoreState>(
        builder: (context, state) {
          if (state.status == PickStoreStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFDD6529)),
            );
          }

          if (state.status == PickStoreStatus.error) {
            return Center(child: Text(state.errorMessage ?? "Unknown error"));
          }

          if (state.stores.isEmpty) {
            return const Center(child: Text("No stores available nearby"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.stores.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final store = state.stores[index];
                    final isSelected = state.selectedStore?.id == store.id;

                    return ShopCard(
                      shop: store,
                      isSelected: isSelected,
                      onTap: () {
                        context.read<PickStoreBloc>().add(SelectShopEvent(shop: store));
                      },
                    );
                  },
                ),
              ),
              BottomShopSelectionBar(
                isEnabled: state.selectedStore != null,
                onConfirm: () {
                   // Navigate to Payment or next step
                },
              ),
            ],
          );
        },
      ),
    );
  }
}