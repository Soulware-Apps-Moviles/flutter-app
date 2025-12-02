import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/orders/domain/shop.dart';
import 'package:tcompro_customer/features/orders/domain/orderline.dart'; // Import OrderLine
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
      create: (context) => OrderReviewBloc()
        ..add(
          LoadOrderReviewEvent(shop: shop, shoppingBag: shoppingBag),
        ),
      child: const _OrderReviewView(),
    );
  }
}

class _OrderReviewView extends StatefulWidget {
  const _OrderReviewView();

  @override
  State<_OrderReviewView> createState() => _OrderReviewViewState();
}

class _OrderReviewViewState extends State<_OrderReviewView> {
  late PickupMethod _selectedPickupMethod;
  late PaymentMethod _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    final state = context.read<OrderReviewBloc>().state;
    if (state.shop != null) {
      _selectedPickupMethod = state.shop!.pickupMethods.first;
      _selectedPaymentMethod = state.shop!.paymentMethods.first;
    }
  }

  // Método auxiliar para mapear ShoppingBag a OrderLines temporalmente
  List<OrderLine> _getOrderLinesFromBag(ShoppingBag bag) {
    return bag.items.map((item) {
      return OrderLine(
        id: 0, // Temporal hasta que se cree la orden real en backend
        name: item.product.name,
        description: item.product.description,
        price: item.product.price,
        quantity: item.quantity,
        catalogProductId: item.product.id,
        imageUrl: item.product.imageUrl,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revisar Orden"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<OrderReviewBloc, OrderReviewState>(
        builder: (context, state) {
          if (state.status == OrderReviewStatus.loading ||
              state.shop == null ||
              state.shoppingBag == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFDD6529)),
            );
          }

          final shop = state.shop!;
          final orderLines = _getOrderLinesFromBag(state.shoppingBag!);
          final double subtotal = orderLines.fold(
              0, (sum, item) => sum + (item.price * item.quantity));

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sección de Información de la Tienda
                      _ShopInfoSection(shop: shop),
                      const SizedBox(height: 24),

                      // Agrupación bajo un solo label
                      const Text(
                        "ENTREGA Y PAGO",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Selectores sin títulos individuales
                      _SelectionField(
                        icon: _getPickupIcon(_selectedPickupMethod),
                        label: _selectedPickupMethod.displayName,
                        placeholder: "Elige método de recojo",
                        onTap: () {
                          // TODO: Implementar cambio
                        },
                      ),
                      const SizedBox(height: 12),
                      _SelectionField(
                        icon: _getPaymentIcon(_selectedPaymentMethod),
                        label: _selectedPaymentMethod.displayName,
                        placeholder: "Elige método de pago",
                        onTap: () {
                          // TODO: Implementar cambio
                        },
                      ),

                      const SizedBox(height: 24),

                      // Listado de Productos (OrderLines)
                      const Text(
                        "PRODUCTOS",
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
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _OrderLineItem(line: orderLines[index]);
                        },
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _BottomOrderBar(
                total: subtotal,
                onConfirm: () {
                  // TODO: Lógica para crear la orden
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

class _OrderLineItem extends StatelessWidget {
  final OrderLine line;

  const _OrderLineItem({required this.line});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Imagen del producto
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(line.imageUrl),
                fit: BoxFit.cover,
                // Manejo de errores simple si la URL falla
                onError: (_, __) {},
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Nombre y precio unitario
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "S/ ${line.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Cantidad y Total de línea
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "x${line.quantity}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "S/ ${(line.price * line.quantity).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDD6529),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShopInfoSection extends StatelessWidget {
  final Shop shop;

  const _ShopInfoSection({required this.shop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.storefront,
                color: Color(0xFFDD6529), size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  shop.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                if (shop.distanceInMeters != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(Icons.location_on,
                            size: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDistance(shop.distanceInMeters!),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    } else {
      return '${meters.round()} m';
    }
  }
}

class _SelectionField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String placeholder;
  final VoidCallback onTap;

  const _SelectionField({
    required this.icon,
    required this.label,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFDD6529)),
            const SizedBox(width: 12),
            Expanded(
              child: label.isEmpty 
              ? Text(
                  placeholder,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _BottomOrderBar extends StatelessWidget {
  final VoidCallback onConfirm;
  final double total;

  const _BottomOrderBar({
    required this.onConfirm,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total a Pagar",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "S/ ${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDD6529),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirmar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}