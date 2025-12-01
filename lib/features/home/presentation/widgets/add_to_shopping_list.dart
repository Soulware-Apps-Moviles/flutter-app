import 'package:flutter/material.dart';

class AddToShoppingListButton extends StatelessWidget {
  final VoidCallback onAddToList; 

  const AddToShoppingListButton({
    super.key, 
    required this.onAddToList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: OutlinedButton(
        onPressed: onAddToList,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFDD6529), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          "Add to shopping list",
          style: TextStyle(
            color: Color(0xFFDD6529),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
