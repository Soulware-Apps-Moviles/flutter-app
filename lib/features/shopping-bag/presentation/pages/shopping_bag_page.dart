import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/core/data/cubits/shopping_bag_cubit.dart';
import 'package:tcompro_customer/features/orders/presentation/pages/pick_store_page.dart';
import 'package:tcompro_customer/features/shopping-bag/presentation/bloc/shopping_bag_bloc.dart';
import 'package:tcompro_customer/features/shopping-bag/presentation/bloc/shopping_bag_event.dart';
import 'package:tcompro_customer/features/shopping-bag/presentation/bloc/shopping_bag_state.dart';
import 'package:tcompro_customer/features/shopping-bag/presentation/widgets/shopping_bag_item.dart';

class ShoppingBagPage extends StatelessWidget {
  const ShoppingBagPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ShoppingBagBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shopping Bag"),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: BlocConsumer<ShoppingBagBloc, ShoppingBagState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ShoppingBagStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.bag.items.isEmpty) {
            return const Center(
              child: Text(
                "Your bag is empty",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.bag.items.length,
                  itemBuilder: (context, index) {
                    final item = state.bag.items[index];
                    return Dismissible(
                      key: Key(item.product.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        bloc.add(RemoveItemFromBag(product: item.product));
                      },
                      child: ShoppingBagItemCard(
                        item: item,
                        onIncrement: (product) {
                          bloc.add(IncrementItemQuantity(product: product));
                        },
                        onDecrement: (product) {
                          bloc.add(DecrementItemQuantity(product: product));
                        },
                      ),
                    );
                  },
                ),
              ),
              _TotalBar(totalPrice: state.bag.totalPrice),
            ],
          );
        },
      ),
    );
  }
}

class _TotalBar extends StatelessWidget {
  final double totalPrice;

  const _TotalBar({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total to pay:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "S/ ${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDD6529),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final currentBag = context.read<ShoppingBagCubit>().state;

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PickStorePage(
                      shoppingBag: currentBag,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDD6529),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Proceed to Checkout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}