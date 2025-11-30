import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/product_detail_bloc.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/product_detail_event.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/product_detail_state.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/add_to_bag_bar.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/add_to_shopping_list.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/product_card.dart';
import 'package:tcompro_customer/shared/domain/product.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  static Route<void> route({required Product product, required int customerId}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ProductDetailBloc(
          repository: context.read<ProductRepository>(),
        )..add(LoadProductDetail(product: product, customerId: customerId)),
        child: const ProductDetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
              buildWhen: (previous, current) =>
                  previous.product?.isFavorite != current.product?.isFavorite,
              builder: (context, state) {
                final product = state.product;
                if (product == null) return const SizedBox.shrink();

                return FavoriteButton(
                  onTap: () {
                    context.read<ProductDetailBloc>().add(
                          ToggleDetailFavorite(product: product),
                        );
                  },
                  isFavorite: product.isFavorite,
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final product = state.product;

          if (product == null) {
             if (state.status == ProductDetailStatus.loading) {
               return const Center(child: CircularProgressIndicator());
             }
             return const Center(child: Text("Product not found"));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      product.imageUrl,
                      height: MediaQuery.of(context).size.height * 0.35,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "S/ ${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const AddToShoppingListButton(),
                  const SizedBox(height: 30),
                  const Text(
                    "You may also like",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _RelatedProductsGrid(state: state),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          return AddToBagBar(price: state.product?.price ?? 0.00);
        },
      ),
    );
  }
}

class _RelatedProductsGrid extends StatelessWidget {
  final ProductDetailState state;

  const _RelatedProductsGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.status == ProductDetailStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ProductDetailStatus.error) {
      return const Center(child: Text("Error loading related products"));
    }

    if (state.relatedProducts.isEmpty) {
      return const Center(child: Text("No related products found"));
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.60,
      ),
      itemCount: state.relatedProducts.length,
      itemBuilder: (context, index) {
        final relatedProduct = state.relatedProducts[index];
        return ProductCard(
          product: relatedProduct,
          onTapFavorite: () {
          },
          onAddToCart: () {
            debugPrint("Bag ${relatedProduct.name}");
          },
        );
      },
    );
  }
}