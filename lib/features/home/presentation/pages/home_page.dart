import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/core/data/cubits/shopping_bag_cubit.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/home_bloc.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/home_event.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/home_state.dart';
import 'package:tcompro_customer/features/home/presentation/pages/product_detail_page.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/category_filter.dart';
import 'package:tcompro_customer/shared/presentation/widgets/product_card.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();

    return SafeArea(
      child: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            onSearch: (query) {
              bloc.add(SearchQuerySent(
                query: query,
                category: bloc.state.selectedCategory
              ));
            },
          ),

          // Category Filters
          CategoryFilter(
            selected: context.watch<HomeBloc>().state.selectedCategory,
            onSelected: (category) {
              bloc.add(CategoryChanged(category: category));
            },
          ),

          // Product Grid
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                switch (state.status) {
                  case Status.loading:
                    return const Center(child: CircularProgressIndicator());
                  case Status.error:
                    return const Center(child: Text("Error loading products"));
                  case Status.loaded:
                    if (state.products.isEmpty) {
                      return const Center(child: Text("No products found"));
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              ProductDetailPage.route(
                                product: product, 
                                customerId: context.read<HomeBloc>().state.customerId!,
                              ),
                            );
                          },
                          child: ProductCard(
                            product: product,
                            onTapFavorite: () {
                              bloc.add(ToggleFavorite(product: product));
                            },
                            onAddToCart: () {
                              context.read<ShoppingBagCubit>().addProduct(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${product.name} added to shopping bag"),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
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