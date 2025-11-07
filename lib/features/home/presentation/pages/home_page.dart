import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_bloc.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_event.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_state.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/category_filter.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/product_card.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProductsBloc>();
    return SafeArea(
      child: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            onSearch: (query) {
              bloc.add(SearchProductsEvent(
                name: query,
                category: bloc.state.selectedCategory == CategoryType.ALL
                    ? CategoryType.ALL.toString()
                    : bloc.state.selectedCategory.name,
              ));
            },
          ),

          // Category Filters
          CategoryFilter(
            selected: context.watch<ProductsBloc>().state.selectedCategory,
            onSelected: (category) {
              bloc.add(LoadProductsEvent(category: category));
            },
          ),

          // Product List
          Expanded(
            child: BlocBuilder<ProductsBloc, ProductsState>(
              builder: (context, state) {
                switch (state.status) {
                  case Status.loading:
                    return const Center(child: CircularProgressIndicator());
                  case Status.error:
                    return const Center(child: Text("Error loading products"));
                  case Status.loaded:
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductCard(
                          product: product,
                          onAddToCart: () {
                            debugPrint("Add ${product.name}");
                          },
                          onFavorite: () {
                            debugPrint("Favorite ${product.name}");
                          },
                        );
                      },
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}