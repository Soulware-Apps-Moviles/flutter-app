import 'package:flutter/material.dart';

class AddToBagButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddToBagButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_shopping_cart),
      onPressed: onPressed,
    );
  }
}