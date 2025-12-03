import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/core/data/cubits/shopping_bag_cubit.dart';
import 'package:tcompro_customer/features/auth/presentation/widgets/shopping_list_picker_modal.dart';
import 'package:tcompro_customer/shared/presentation/widgets/favorite_button.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/product_detail_bloc.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/product_detail_event.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/product_detail_state.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/add_to_bag_bar.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/add_to_shopping_list.dart';
import 'package:tcompro_customer/shared/presentation/widgets/product_card.dart';
import 'package:tcompro_customer/shared/domain/shopping_list.dart';
import 'package:tcompro_customer/features/shopping-lists/presentation/bloc/shopping_lists_bloc.dart';
import 'package:tcompro_customer/shared/domain/product.dart';
import 'package:tcompro_customer/shared/domain/product_repository.dart';
import 'package:tcompro_customer/shared/domain/shopping_list_repository.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  static Route<void> route({required Product product, required int customerId}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ProductDetailBloc(
          productRepository: context.read<ProductRepository>(),
          shoppingListRepository: context.read<ShoppingListRepository>()
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
                          ToggleFavorite(product: product),
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
                      errorBuilder: (_, _, _) =>
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
                  AddToShoppingListButton(
                    onAddToList: () {
                      final shoppingListState = context.read<ShoppingListsBloc>().state;
                      
                      if (shoppingListState.shoppingLists.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("You don't have any shopping lists yet."))
                        );
                        return;
                      }

                      showShoppingListPicker(
                        context: context,
                        lists: shoppingListState.shoppingLists,
                        onSelect: (selectedList) {
                          
                          context.read<ProductDetailBloc>().add(
                            AddToShoppingList(
                              product: product,
                              list: selectedList,
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Added to ${selectedList.name}")),
                          );
                        },
                      );
                    },
                  ),
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
          return AddToBagBar(
            price: state.product?.price ?? 0.00,
            onTap: () {
              context.read<ShoppingBagCubit>().addProduct(state.product!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${state.product!.name} added to shopping bag"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
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
            context.read<ShoppingBagCubit>().addProduct(relatedProduct);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${relatedProduct.name} added to shopping bag"),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }
}

void showShoppingListPicker({
  required BuildContext context,
  required List<ShoppingList> lists,
  required Function(ShoppingList) onSelect,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) => ShoppingListPickerModal(
        shoppingLists: lists,
        onSelect: onSelect,
        scrollController: controller,
      ),
    ),
  );
}