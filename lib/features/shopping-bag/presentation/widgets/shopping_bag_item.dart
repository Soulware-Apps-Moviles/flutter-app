import 'package:flutter/material.dart';
import 'package:tcompro_customer/shared/domain/bag_item.dart';
import 'package:tcompro_customer/shared/domain/product.dart';

class ShoppingBagItemCard extends StatelessWidget {
  final BagItem item;
  
  final void Function(Product) onIncrement;
  final void Function(Product) onDecrement;

  const ShoppingBagItemCard({
    super.key, 
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 2. Datos y Controles
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Precio Unitario
                  Text(
                    "S/ ${product.price.toStringAsFixed(2)} / ud",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Controles e Importe
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            _QuantityButton(
                              icon: Icons.remove,
                              onTap: () => onDecrement(product), // Ejecuta callback
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            _QuantityButton(
                              icon: Icons.add,
                              color: const Color(0xFFDD6529),
                              onTap: () => onIncrement(product), // Ejecuta callback
                            ),
                          ],
                        ),
                      ),

                      // Subtotal
                      Text(
                        "S/ ${item.subtotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDD6529),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          icon,
          size: 20,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }
}