import 'package:flutter/material.dart';
import 'package:tcompro_customer/shared/domain/shopping_list_item.dart';

class ShoppingListItemCard extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ShoppingListItemCard({
    super.key,
    required this.item,
    required this.onAddToCart,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and delete button
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Image.network(
                        "https://www.costaoil.com.co/wp-content/uploads/2025/01/sinimagen.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),

          // Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),

          // Price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'S/ ${item.price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
            ),
          ),

          const SizedBox(height: 8),

          // Quantity Controls Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QuantityButton(
                  icon: Icons.remove,
                  onTap: onDecrement,
                ),
                Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _QuantityButton(
                  icon: Icons.add,
                  onTap: onIncrement,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Add to cart button
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDD6529),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  minimumSize: const Size(0, 36), // Altura compacta
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.add_shopping_cart_outlined, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey.shade50,
        ),
        child: Icon(icon, size: 16, color: Colors.grey.shade700),
      ),
    );
  }
}