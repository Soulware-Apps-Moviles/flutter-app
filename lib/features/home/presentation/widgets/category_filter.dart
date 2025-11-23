import 'package:flutter/material.dart';
import 'package:tcompro_customer/features/home/domain/category.dart';

class CategoryFilter extends StatelessWidget {
  final CategoryType selected;
  final Function(CategoryType) onSelected;

  const CategoryFilter({
    super.key, 
    required this.selected, 
    required this.onSelected
    });

@override
  Widget build(BuildContext context) {
    final categories = CategoryType.values;
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selected;
          return GestureDetector(
            onTap: () => onSelected(category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
                  decorationThickness: 2,
                  decorationColor: Colors.black
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}