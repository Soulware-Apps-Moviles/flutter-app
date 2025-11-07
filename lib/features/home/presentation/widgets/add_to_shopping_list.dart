import 'package:flutter/material.dart';

class AddToShoppingListButton extends StatelessWidget {
  const AddToShoppingListButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: OutlinedButton(
        onPressed: () {}, // Add logic here
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
