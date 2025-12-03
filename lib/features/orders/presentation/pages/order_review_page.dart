import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/core/data/cubits/profile_cubit.dart';
import 'package:tcompro_customer/features/orders/domain/order_line.dart';
import 'package:tcompro_customer/features/orders/domain/order_repository.dart';
import 'package:tcompro_customer/features/orders/domain/payment_method.dart';
import 'package:tcompro_customer/features/orders/domain/pickup_method.dart';
import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/shared/domain/shopping_bag.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/order_review_bloc.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/order_review_event.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/order_review_state.dart';
import 'package:tcompro_customer/features/orders/presentation/widgets/bottom_order_bar.dart';
import 'package:tcompro_customer/features/orders/presentation/widgets/order_line_item.dart';
import 'package:tcompro_customer/features/orders/presentation/widgets/selection_field.dart';
import 'package:tcompro_customer/features/orders/presentation/widgets/shop_info_section.dart';

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
      create: (context) {
        final profileState = context.read<ProfileCubit>().state;
        final int customerId = profileState?.id ?? 0;

        if (customerId == 0) {
           debugPrint("Warning: Customer ID not found in ProfileCubit");
        }

        return OrderReviewBloc(
          orderRepository: context.read<OrderRepository>(),
        )..add(
            LoadOrderReviewEvent(
              shop: shop, 
              shoppingBag: shoppingBag,
              customerId: customerId, 
            ),
          );
      },
      child: BlocListener<OrderReviewBloc, OrderReviewState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == OrderReviewStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? "Unknown error"), backgroundColor: Colors.red),
            );
          }
          
          if (state.status == OrderReviewStatus.success && state.createdOrder != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Order created successfully!"), backgroundColor: Color(0xFFDD6529),),
            );
            // TODO: Navigate to Order Tracking
          }
        },
        child: const _OrderReviewView(),
      ),
    );
  }
}

class _OrderReviewView extends StatefulWidget {
  const _OrderReviewView();

  @override
  State<_OrderReviewView> createState() => _OrderReviewViewState();
}

class _OrderReviewViewState extends State<_OrderReviewView> {
  
  List<OrderLine> _getOrderLinesFromBag(ShoppingBag bag) {
    return bag.items.map((item) {
      return OrderLine(
        id: 0,
        name: item.product.name,
        description: item.product.description,
        price: item.product.price,
        quantity: item.quantity,
        catalogProductId: item.product.id,
        imageUrl: item.product.imageUrl,
      );
    }).toList();
  }

  void _showMethodSelectionModal<T>({
    required BuildContext context,
    required String title,
    required List<T> methods,
    required Function(T) onSelect,
    required String Function(T) getDisplayName,
    required T? selectedItem,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (methods.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text("No options available."),
                ),
              ...methods.map((method) {
                final isSelected = method == selectedItem;
                return ListTile(
                  title: Text(
                    getDisplayName(method),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFFDD6529) : Colors.black87,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Color(0xFFDD6529))
                      : null,
                  onTap: () {
                    onSelect(method);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Order"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<OrderReviewBloc, OrderReviewState>(
        builder: (context, state) {
          if (state.status == OrderReviewStatus.loading ||
              state.status == OrderReviewStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFDD6529)),
            );
          }
          
          if (state.status == OrderReviewStatus.submitting) {
             return const Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   CircularProgressIndicator(color: Color(0xFFDD6529)),
                   SizedBox(height: 16),
                   Text("Processing order...")
                 ],
               ),
             );
          }

          final shop = state.shop!;
          final shoppingBag = state.shoppingBag!;
          final orderLines = _getOrderLinesFromBag(shoppingBag);
          final double subtotal = orderLines.fold(
              0, (sum, item) => sum + (item.price * item.quantity));
          
          final selectedPickup = state.selectedPickupMethod;
          final selectedPayment = state.selectedPaymentMethod;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShopInfoSection(shop: shop),
                      const SizedBox(height: 24),

                      const Text(
                        "DELIVERY & PAYMENT",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Selector de Recojo
                      SelectionField(
                        icon: selectedPickup != null 
                            ? _getPickupIcon(selectedPickup) 
                            : Icons.local_shipping_outlined,
                        label: selectedPickup?.displayName ?? '',
                        placeholder: "Select a pickup method",
                        onTap: () {
                          _showMethodSelectionModal<PickupMethod>(
                            context: context,
                            title: "Pickup Method",
                            methods: shop.pickupMethods,
                            selectedItem: selectedPickup,
                            getDisplayName: (m) => m.displayName,
                            onSelect: (method) {
                              context.read<OrderReviewBloc>().add(
                                ChangePickupMethodEvent(method: method)
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Selector de Pago
                      SelectionField(
                        icon: selectedPayment != null 
                            ? _getPaymentIcon(selectedPayment) 
                            : Icons.payment_outlined,
                        label: selectedPayment?.displayName ?? '',
                        placeholder: "Select a payment method",
                        onTap: () {
                          _showMethodSelectionModal<PaymentMethod>(
                            context: context,
                            title: "Payment Method",
                            methods: shop.paymentMethods,
                            selectedItem: selectedPayment,
                            getDisplayName: (m) => m.displayName,
                            onSelect: (method) {
                              context.read<OrderReviewBloc>().add(
                                ChangePaymentMethodEvent(method: method)
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        "PRODUCTS",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orderLines.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return OrderLineItem(line: orderLines[index]);
                        },
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              BottomOrderBar(
                total: subtotal,
                onConfirm: () {
                  context.read<OrderReviewBloc>().add(PlaceOrderEvent());
                },
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getPaymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.attach_money;
      case PaymentMethod.onCredit:
        return Icons.credit_score;
      case PaymentMethod.virtual:
        return Icons.qr_code_2;
    }
  }

  IconData _getPickupIcon(PickupMethod method) {
    switch (method) {
      case PickupMethod.delivery:
        return Icons.local_shipping;
      case PickupMethod.shopPickUp:
        return Icons.store;
    }
  }
}