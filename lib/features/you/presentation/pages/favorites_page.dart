import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/core/data/cubits/shopping_bag_cubit.dart';import 'package:tcompro_customer/features/home/presentation/pages/product_detail_page.dart';
import 'package:tcompro_customer/features/you/presentation/bloc/favorites_bloc.dart';
import 'package:tcompro_customer/features/you/presentation/bloc/favorites_event.dart';
import 'package:tcompro_customer/features/you/presentation/bloc/favorites_state.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';
import 'package:tcompro_customer/shared/presentation/widgets/product_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  static Route<void> route({required int customerId}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => FavoritesBloc(
          productRepository: context.read<ProductRepository>(),
        )..add(LoadFavoritesEvent(customerId: customerId)),
        child: const FavoritesPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.status == FavoritesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FavoritesStatus.error) {
            return Center(child: Text(state.errorMessage ?? "Error loading favorites"));
          }

          if (state.products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No favorites yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

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
              return GestureDetector(
                onTap: () {
                  if (state.customerId != null) {
                    Navigator.push(
                      context,
                      ProductDetailPage.route(
                        product: product,
                        customerId: state.customerId!,
                      ),
                    );
                  }
                },
                child: ProductCard(
                  product: product,
                  onTapFavorite: () {
                    context.read<FavoritesBloc>().add(
                      ToggleFavoriteInList(product: product),
                    );
                  },
                  onAddToCart: () {
                    context.read<ShoppingBagCubit>().addProduct(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${product.name} added to shopping bag"),
                        duration: const Duration(seconds: 1),
                        backgroundColor: const Color(0xFFDD6529),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}