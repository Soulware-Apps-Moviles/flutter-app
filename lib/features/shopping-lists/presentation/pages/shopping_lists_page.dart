import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/search_bar.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_bloc.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_event.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_state.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/widgets/add_shopping_list_form.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/widgets/shopping_list_card.dart';


class ShoppingListsPage extends StatefulWidget {
  const ShoppingListsPage({super.key});

  @override
  State<ShoppingListsPage> createState() => _ShoppingListsPageState();
}

class _ShoppingListsPageState extends State<ShoppingListsPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ShoppingListsBloc>().add(LoadShoppingListsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ShoppingListsBloc, ShoppingListsState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
      
            final lists = state.shoppingLists
                .where((l) => l.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                .toList();
      
            return SingleChildScrollView(
              child: Column(
                children: [
                  SearchBarWidget(onSearch: (query) => setState(() => _searchQuery = query)),
                  ...lists.map((list) => ShoppingListCard(
                        list: list,
                        onAddAllToBag: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added all items from ${list.name}')),
                          );
                        },
                      )),
                  AddShoppingListWidget(
                    onAdd: (name) => context.read<ShoppingListsBloc>().add(
                          CreateShoppingListEvent(customerId: int.parse(dotenv.env['CUSTOMER_ID'] ?? '0'), name: name),
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
