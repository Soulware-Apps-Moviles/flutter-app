import 'package:flutter/material.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/add_to_bag_button.dart';
import 'package:tcompro_customer/features/shopping-lists/domain/shopping_list.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(list.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: list.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.network(item.imageUrl, width: 60, height: 60),
                  );
                }).toList(),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: AddToBagButton(onPressed: onAddAllToBag),
            ),
          ],
        ),
      ),
    );
  }
}
