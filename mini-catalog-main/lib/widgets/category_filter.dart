import 'package:flutter/material.dart';
import '../helpers/category_helpers.dart';

/// Kategori filtreleme chip'leri widget'ı.
/// Yatay ListView.builder ile kaydırılabilir chip listesi gösterir.
class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = selectedCategory == null;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: isSelected
                    ? null
                    : Icon(Icons.grid_view_rounded,
                        size: 16, color: Colors.grey.shade600),
                label: const Text('Tümü'),
                selected: isSelected,
                onSelected: (_) => onCategorySelected(null),
                selectedColor: theme.colorScheme.primary.withOpacity(0.15),
                checkmarkColor: theme.colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.grey.shade700,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary.withOpacity(0.3)
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            );
          }

          final category = categories[index - 1];
          final isSelected = selectedCategory == category;
          final catColor = CategoryHelpers.getColor(category);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              avatar: isSelected
                  ? null
                  : Icon(CategoryHelpers.getIcon(category),
                      size: 16, color: catColor),
              label: Text(category),
              selected: isSelected,
              onSelected: (_) {
                onCategorySelected(isSelected ? null : category);
              },
              selectedColor: catColor.withOpacity(0.15),
              checkmarkColor: catColor,
              labelStyle: TextStyle(
                color: isSelected ? catColor : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? catColor.withOpacity(0.3)
                      : Colors.grey.shade300,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
