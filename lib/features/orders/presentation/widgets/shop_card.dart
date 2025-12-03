import 'package:flutter/material.dart';
import 'package:tcompro_customer/features/orders/domain/payment_method.dart';
import 'package:tcompro_customer/features/orders/domain/pickup_method.dart';
import 'package:tcompro_customer/features/orders/domain/shop.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;
  final bool isSelected;
  final VoidCallback onTap;

  const ShopCard({
    super.key,
    required this.shop,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFDD6529) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0E6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.storefront, color: Color(0xFFDD6529), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black87,
                          ),
                        ),
                        if (shop.distanceInMeters != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 2),
                              Text(
                                _formatDistance(shop.distanceInMeters!),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check_circle, color: Color(0xFFDD6529), size: 28),
                    ),
                ],
              ),
              
              const SizedBox(height: 16),

              if (shop.pickupMethods.isNotEmpty) ...[
                const Text(
                  "PICK UP METHODS",
                  style: TextStyle(
                    fontSize: 10, 
                    color: Colors.grey, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: shop.pickupMethods.map((method) {
                      return _MethodChip(
                        icon: _getPickupIcon(method),
                        label: method.displayName,
                        backgroundColor: Colors.orange.shade50,
                        contentColor: Colors.orange.shade800,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (shop.paymentMethods.isNotEmpty) ...[
                const Text(
                  "PAYMENT METHODS",
                  style: TextStyle(
                    fontSize: 10, 
                    color: Colors.grey, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: shop.paymentMethods.map((method) {
                      return _MethodChip(
                        icon: _getPaymentIcon(method),
                        label: method.displayName,
                        backgroundColor: Colors.grey.shade100,
                        contentColor: Colors.grey.shade700,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
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

class _MethodChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color contentColor;

  const _MethodChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: contentColor.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: contentColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }
}