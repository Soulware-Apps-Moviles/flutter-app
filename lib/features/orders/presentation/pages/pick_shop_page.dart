import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/orders/domain/order_repository.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_shop_bloc.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_shop_event.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_shop_state.dart';
import 'package:tcompro_customer/features/orders/presentation/pages/order_review_page.dart';
import 'package:tcompro_customer/features/orders/presentation/widgets/shop_card.dart';
import 'package:tcompro_customer/features/orders/presentation/widgets/bottom_shop_selection_bar.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';

class PickShopPage extends StatelessWidget {
  final ShoppingBag shoppingBag;

  const PickShopPage({
    super.key,
    required this.shoppingBag,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PickShopBloc(
        orderRepository: context.read<OrderRepository>(),
      )..add(LoadShopEvent(shoppingBag)),
      child: _PickStoreView(shoppingBag: shoppingBag),
    );
  }
}

class _PickStoreView extends StatelessWidget {
  final ShoppingBag shoppingBag;

  const _PickStoreView({required this.shoppingBag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Store"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<PickShopBloc, PickShopState>(
        builder: (context, state) {
          if (state.status == PickShopStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFDD6529)),
            );
          }

          if (state.status == PickShopStatus.error) {
            return Center(child: Text(state.errorMessage ?? "Unknown error"));
          }

          if (state.shops.isEmpty) {
            return const Center(child: Text("No stores available nearby"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.shops.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final store = state.shops[index];
                    final isSelected = state.selectedStore?.id == store.id;

                    return ShopCard(
                      shop: store,
                      isSelected: isSelected,
                      onTap: () {
                        context.read<PickShopBloc>().add(SelectShopEvent(shop: store));
                      },
                    );
                  },
                ),
              ),
              BottomShopSelectionBar(
                isEnabled: state.selectedStore != null,
                onConfirm: () {
                  if (state.selectedStore != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderReviewPage(
                          shop: state.selectedStore!,
                          shoppingBag: shoppingBag,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}