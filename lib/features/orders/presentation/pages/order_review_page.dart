import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/order_review_bloc.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/order_review_event.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/order_review_state.dart';

class OrderReviewPage extends StatelessWidget {
  final Shop shop;
  final ShoppingBag shoppingBag;

  const OrderReviewPage({
    super.key,
    required this.shop,
    required this.shoppingBag,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderReviewBloc()..add(
        LoadOrderReviewEvent(shop: shop, shoppingBag: shoppingBag),
      ),
      child: const _OrderReviewView(),
    );
  }
}

class _OrderReviewView extends StatelessWidget {
  const _OrderReviewView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Order"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: BlocBuilder<OrderReviewBloc, OrderReviewState>(
        builder: (context, state) {
          return const Center(
            child: Text("it works"),
          );
        },
      ),
    );
  }
}