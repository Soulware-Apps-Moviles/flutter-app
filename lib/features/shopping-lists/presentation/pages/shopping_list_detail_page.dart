import 'package:flutter/material.dart';
import 'package:tcompro_customer/features/shopping-lists/domain/shopping_list.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/widgets/delete_shopping_list_button.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/widgets/shopping_list_item_card.dart';

class ShoppingListDetailPage extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListDetailPage({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true, 
        title: Text(
          list.name,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: DeleteShoppingListButton(
              onDelete: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted shopping list "${list.name}"'),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Items grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: list.items.length,
                itemBuilder: (context, index) {
                  final item = list.items[index];
                  return ShoppingListItemCard(
                    item: item,
                    onAddToCart: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added ${item.name} to bag')),
                      );
                    },
                    onRemove: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Removed ${item.name}')),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
