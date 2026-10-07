import 'package:flutter/material.dart';

class CategoryStep extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final Function(Map<String, dynamic>) onCategorySelected;

  const CategoryStep({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (ctx, idx) {
        final cat = categories[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Text(cat['icon'] ?? '📷', style: const TextStyle(fontSize: 28)),
            title: Text(cat['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(cat['description'] ?? '', style: const TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => onCategorySelected(cat),
          ),
        );
      },
    );
  }
}
