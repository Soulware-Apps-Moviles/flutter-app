import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/search_bar.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_bloc.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_event.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_state.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/pages/shopping_list_detail_page.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/widgets/add_shopping_list_modal.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/widgets/shopping_list_card.dart';

class ShoppingListsPage extends StatelessWidget {
  const ShoppingListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ShoppingListsBloc>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddShoppingListModal(context);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            SearchBarWidget(
              onSearch: (query) {
                bloc.add(SearchShoppingListsEvent(name: query));
              },
            ),

            // Lists
            Expanded(
              child: BlocBuilder<ShoppingListsBloc, ShoppingListsState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.shoppingLists.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text('No shopping lists found.'),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      final currentId = state.customerId;
                      if (currentId != null) {
                        bloc.add(LoadShoppingListsEvent(customerId: currentId));
                      }
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.shoppingLists.length,
                      itemBuilder: (context, index) {
                        final list = state.shoppingLists[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ShoppingListDetailPage(list: list),
                              ),
                            );
                          },
                          child: ShoppingListCard(
                            list: list,
                            onAddAllToBag: () {
                              bloc.add(AddListToBagEvent(list: list));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added all items from ${list.name}',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddShoppingListModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AddShoppingListModal(
      onAdd: (name) {
        context.read<ShoppingListsBloc>().add(
          CreateShoppingListEvent(name: name),
        );
      },
    ),
  );
}
}
