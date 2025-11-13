import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/search_bar.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_bloc.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_event.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_state.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/widgets/add_shopping_list_form.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/widgets/shopping_list_card.dart';

class ShoppingListsPage extends StatelessWidget {
  const ShoppingListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ShoppingListsBloc>();

    return SafeArea(
      child: Column(
        children: [
          //Search bar
          SearchBarWidget(
            onSearch: (query) {
              bloc.add(SearchShoppingListsEvent(name: query));
            },
          ),

          // Shopping lists + add form
          Expanded(
            child: BlocBuilder<ShoppingListsBloc, ShoppingListsState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.shoppingLists.isEmpty) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text('No shopping lists found.'),
                        ),
                      ),
                      _buildAddShoppingListWidget(context),
                    ],
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    bloc.add(LoadShoppingListsEvent());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.shoppingLists.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.shoppingLists.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 24),
                          child: _buildAddShoppingListWidget(context),
                        );
                      }

                      final list = state.shoppingLists[index];
                      return ShoppingListCard(
                        list: list,
                        onAddAllToBag: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added all items from ${list.name}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAddShoppingListWidget(BuildContext context) {
    final customerId = int.parse(dotenv.env['CUSTOMER_ID'] ?? '0');

    return AddShoppingListWidget(
      onAdd: (name) {
        context.read<ShoppingListsBloc>().add(
              CreateShoppingListEvent(
                customerId: customerId,
                name: name,
              ),
            );
      },
    );
  }
}
