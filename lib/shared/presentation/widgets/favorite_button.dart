import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isFavorite;

  const FavoriteButton({
    super.key,
    required this.onTap,
    required this.isFavorite
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.black,
      ),
    );
  }
}
