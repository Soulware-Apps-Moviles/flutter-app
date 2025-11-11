import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tcompro_customer/features/home/domain/product.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_bloc.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_event.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/products_state.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/add_to_bag_bar.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/add_to_shopping_list.dart';
import 'package:tcompro_customer/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:tcompro_customer/features/home/presentation/widgets/product_card.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

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
          child: FavoriteButton(
            productId: product.id,
            customerId: int.tryParse(dotenv.env['CUSTOMER_ID'] ?? '') ?? 0, // TO TEST
          ),
        ),
      ],

      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
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

              // Name
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Price
              Text(
                "S/ ${product.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Add to shopping list button
              const AddToShoppingListButton(),
              const SizedBox(height: 30),

              // Similar products section
              const Text(
                "You may also like",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              BlocBuilder<ProductsBloc, ProductsState>(
                bloc: BlocProvider.of<ProductsBloc>(context)
                  ..add(LoadProductsEvent(category: product.category)),
                builder: (context, state) {
                  switch (state.status) {
                    case Status.loading:
                      return const Center(child: CircularProgressIndicator());
                    case Status.error:
                      return const Center(
                          child: Text("Error loading products"));
                    case Status.loaded:
                      if (state.products.isEmpty) {
                        return const Center(
                            child: Text("No related products found"));
                      }
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(), // avoid nested scrolling
                        shrinkWrap: true, // allows it to grow within the main scroll
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.60,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final relatedProduct = state.products[index];
                          return ProductCard(
                            product: relatedProduct,
                            onAddToCart: () {
                              debugPrint("Add ${relatedProduct.name}");
                            },
                          );
                        },
                      );
                    default:
                      return const SizedBox();
                  }
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      //  Add to bag bar
      bottomNavigationBar: AddToBagBar(price: 0.00),
    );
  }
}
