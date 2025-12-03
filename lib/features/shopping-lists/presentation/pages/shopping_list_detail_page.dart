import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_list_detail_bloc.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_list_detail_event.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_list_detail_state.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';
import 'package:tcompro_customer/shared/domain/shopping_list.dart';
import 'package:tcompro_customer/shared/domain/shopping_list_repository.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/widgets/shopping_list_item_card.dart';

class ShoppingListDetailPage extends StatelessWidget {
  const ShoppingListDetailPage({super.key});

  static Route<void> route({required ShoppingList initialList, required int customerId}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ShoppingListDetailBloc(
          shoppingListRepository: context.read<ShoppingListRepository>(),
          productRepository: context.read<ProductRepository>(),
        )..add(LoadShoppingListDetail(initialList: initialList, customerId: customerId)),
        child: const ShoppingListDetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppingListDetailBloc, ShoppingListDetailState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
          );
        }
        if (state.actionMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.actionMessage!)),
          );
        }
      },
      builder: (context, state) {
        final list = state.list;

        if (state.status == ShoppingListDetailStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (list == null) {
          return const Scaffold(
            body: Center(child: Text("List not found or error loading")),
          );
        }

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
                        
                        // 1. Incrementar Cantidad en la Lista
                        onIncrement: () {
                          context.read<ShoppingListDetailBloc>().add(UpdateItemQuantity(
                            item: item,
                            newQuantity: item.quantity + 1
                          ));
                        },

                        // 2. Disminuir Cantidad en la Lista
                        onDecrement: () {
                          if (item.quantity > 1) {
                            context.read<ShoppingListDetailBloc>().add(UpdateItemQuantity(
                              item: item,
                              newQuantity: item.quantity - 1
                            ));
                          }
                        },

                        // 3. Eliminar Item de esta Lista (quantity = 0)
                        onRemove: () {
                          context.read<ShoppingListDetailBloc>().add(UpdateItemQuantity(
                            item: item,
                            newQuantity: 0
                          ));
                        },

                        // 4. Agregar al Carrito Global (Shopping Bag)
                        onAddToCart: () {
                          context.read<ShoppingListDetailBloc>().add(
                            AddItemToBag(item: item)
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
      },
    );
  }
}