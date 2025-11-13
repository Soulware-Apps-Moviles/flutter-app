import 'package:flutter/material.dart';

class DeleteShoppingListButton extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteShoppingListButton({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_outlined, color: Colors.black),
      tooltip: 'Delete shopping list',
      onPressed: onDelete,
    );
  }
}
