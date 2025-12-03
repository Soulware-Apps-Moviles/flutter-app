import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_bloc.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_event.dart';
import 'package:tcompro_customer/shared/domain/shopping_list.dart';
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.65,
                ),
                itemCount: list.items.length,
                itemBuilder: (context, index) {
                  final item = list.items[index];
                  return ShoppingListItemCard(
                    item: item,
                    
                    onIncrement: () {
                      context.read<ShoppingListsBloc>().add(UpdateItemQuantityEvent(
                        list: list,
                        item: item,
                        newQuantity: item.quantity + 1
                      ));
                    },

                    // 2. Disminuir Cantidad en la Lista
                    onDecrement: () {
                      if (item.quantity > 1) {
                        context.read<ShoppingListsBloc>().add(UpdateItemQuantityEvent(
                        list: list,
                        item: item,
                        newQuantity: item.quantity - 1
                      ));
                      }
                    },

                    // 3. Eliminar Item de esta Lista
                    onRemove: () {
                      context.read<ShoppingListsBloc>().add(UpdateItemQuantityEvent(
                        list: list,
                        item: item,
                        newQuantity: 0
                      ));
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Removed ${item.name} from list')),
                      );
                    },

                    // 4. Agregar al Carrito Global (Shopping Bag)
                    onAddToCart: () {
                      // BLOC LOGIC:
                      // context.read<ShoppingBagCubit>().addProduct(
                      //   item.toProduct.copyWith(quantity: item.quantity) // Usamos toProduct que ya definiste
                      // );
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added ${item.quantity} x ${item.name} to Main Bag')),
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