import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/home/domain/category.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_bloc.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_event.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_state.dart';
import 'package:tcompro_customer/features/home/presentation/pages/product_detail_page.dart';
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

          // Product Grid
          Expanded(
            child: BlocBuilder<ProductsBloc, ProductsState>(
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
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailPage(product: product),
                              ),
                            );
                          },
                          child: ProductCard(
                            product: product,
                            onAddToCart: () {
                              debugPrint("Add ${product.name}");
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