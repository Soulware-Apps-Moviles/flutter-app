import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/favorites/domain/entities/favorite.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:tcompro_customer/features/favorites/presentation/bloc/favorites_state.dart';

class FavoriteButton extends StatelessWidget {
  final int productId;
  final int customerId;

  const FavoriteButton({
    super.key,
    required this.productId,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state.favoriteProducts.any(
          (f) => f.productId == productId,
        );

        return IconButton(
          onPressed: () {
            final favorite = Favorite(
              id: 0,
              productId: productId,
              customerId: customerId,
            );

            context
                .read<FavoritesBloc>()
                .add(ToggleFavoriteEvent(favorite: favorite));
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.black,
          ),
        );
      },
    );
  }
}
