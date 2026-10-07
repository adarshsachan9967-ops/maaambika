import 'package:flutter/material.dart';

class ModelStep extends StatelessWidget {
  final List<Map<String, dynamic>> models;
  final Function(Map<String, dynamic>) onModelSelected;

  const ModelStep({
    super.key,
    required this.models,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (models.isEmpty) {
      return const Center(child: Text('No models found for this category'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: models.length,
      itemBuilder: (ctx, idx) {
        final m = models[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(m['name'] ?? m['model'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Base valuation: ₹${m['basePrice'] ?? 0}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => onModelSelected(m),
          ),
        );
      },
    );
  }
}
