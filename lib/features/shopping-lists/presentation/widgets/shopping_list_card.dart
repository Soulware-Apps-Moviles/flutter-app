import 'package:flutter/material.dart';
import 'package:tcompro_customer/shared/domain/shopping_list.dart';

class ShoppingListCard extends StatelessWidget {
  final ShoppingList list;
  final VoidCallback onAddAllToBag;

  const ShoppingListCard({
    super.key,
    required this.list,
    required this.onAddAllToBag,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              list.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            
            const SizedBox(height: 6),

            Row(
              children: [
                _buildStatBadge(Icons.receipt_long_outlined, "${list.items.length} products"),
                const SizedBox(width: 16),
                _buildStatBadge(Icons.layers_outlined, "${list.totalUnits} units"),
              ],
            ),
            
            const SizedBox(height: 12),
            
            _buildProductGallery(context),
            
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAddAllToBag,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDD6529),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add List to Cart",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.add_shopping_cart_outlined, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProductGallery(BuildContext context) {
    if (list.items.isEmpty) {
      return Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Text(
            "No products",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final int displayCount = list.items.length > 4 ? 4 : list.items.length;
    final bool showOverflow = list.items.length > 4;

    return SizedBox(
      height: 80,
      child: Row(
        children: List.generate(displayCount, (index) {
          final item = list.items[index];
          final isLastItem = index == displayCount - 1;
          
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLastItem ? 0 : 8.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: Colors.grey.shade100,
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  if (isLastItem && showOverflow)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '+${list.items.length - 3}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}