import 'package:flutter/material.dart';
import 'package:tcompro_customer/features/shopping-lists/domain/shopping_list_item.dart';

class ShoppingListItemCard extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;

  const ShoppingListItemCard({
    super.key,
    required this.item,
    required this.onAddToCart,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and delete button
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  item.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.black),
                onPressed: onRemove,
              ),
            ],
          ),

          // Quantity
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text('${item.quantity}x',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),

          // Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          // Price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text('S/ ${item.price.toStringAsFixed(2)}'),
          ),

          const Spacer(),

          // Add to cart button
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(Icons.add_shopping_cart_outlined),
              onPressed: onAddToCart,
            ),
          ),
        ],
      ),
    );
  }
}
