import 'package:flutter/material.dart';

class CategorySelectionDialog extends StatelessWidget {
  final IconData selectedCategoryIcon;
  CategorySelectionDialog({required this.selectedCategoryIcon});

  // Map of category icons
  final Map<String, IconData> categoryIcons = {
    'Groceries': Icons.shopping_cart,
    'Utilities': Icons.settings,
    'Transportation': Icons.directions_car,
    'Healthcare': Icons.local_hospital,
    'Entertainment': Icons.movie,
    'Dining Out': Icons.restaurant,
    'Shopping': Icons.shopping_bag,
    'Home Maintenance': Icons.home_repair_service,
    'Travel': Icons.airplane_ticket,
    'Miscellaneous': Icons.category,
    'Education': Icons.book,
  };
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Your dialog UI here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: categoryIcons.entries.map((MapEntry<String, IconData> entry) {
          return ListTile(
            leading: Icon(entry.value),
            title: Text(entry.key),
            onTap: () {
              // Handle category selection
              Navigator.pop(context, {
                'category': entry.key,
                'icon': entry.value,
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
