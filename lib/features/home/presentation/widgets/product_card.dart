import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tcompro_customer/features/home/domain/product.dart';
import 'package:tcompro_customer/features/favorites/presentation/widgets/favorite_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Favorite Button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FavoriteButton(
                  productId: product.id,
                  customerId: int.tryParse(dotenv.env['CUSTOMER_ID'] ?? '') ?? 0, // TO TEST
                ),
              ),
            ],
          ),

          // Product Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('S/ ${product.price.toStringAsFixed(2)}'),
          ),

          const Spacer(),

          // Add to cart button
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(Icons.add_shopping_cart_outlined),
              onPressed: onAddToCart,
            ),
          ),
        ],
      ),
    );
  }
}
