import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';

class ExchangeSelectNewStep extends StatelessWidget {
  final List<Map<String, dynamic>> newProducts;
  final Function(Map<String, dynamic>) onNewProductSelected;

  const ExchangeSelectNewStep({
    super.key,
    required this.newProducts,
    required this.onNewProductSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: newProducts.length,
      itemBuilder: (ctx, idx) {
        final p = newProducts[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(p['model'] ?? p['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Price: ${formatCurrency(p['sellingPrice'] ?? 0)}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => onNewProductSelected(p),
          ),
        );
      },
    );
  }
}
