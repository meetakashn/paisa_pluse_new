import 'package:flutter/material.dart';

class IncomeCategorySelectionDialog extends StatelessWidget {
  final IconData selectedCategoryIcon;

  IncomeCategorySelectionDialog({required this.selectedCategoryIcon});

  // Map of category icons
  final Map<String, IconData> incomeCategoryIcons = {
    'Salary': Icons.attach_money,
    'Freelance': Icons.work,
    'Business': Icons.business,
    'Investments': Icons.trending_up,
    'Gifts': Icons.card_giftcard,
    'Rent': Icons.home,
    'Side Hustle': Icons.star,
    'Refunds': Icons.refresh,
    'Other': Icons.category,
  };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Your dialog UI here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            incomeCategoryIcons.entries.map((MapEntry<String, IconData> entry) {
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
