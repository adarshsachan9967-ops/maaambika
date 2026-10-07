import 'package:flutter/material.dart';

class ExchangeSelectOldStep extends StatelessWidget {
  final List<Map<String, dynamic>> devices;
  final Function(Map<String, dynamic>) onDeviceSelected;

  const ExchangeSelectOldStep({
    super.key,
    required this.devices,
    required this.onDeviceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: devices.length,
      itemBuilder: (ctx, idx) {
        final d = devices[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(d['name'] ?? d['model'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Base exchange value: ₹${d['basePrice'] ?? 0}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => onDeviceSelected(d),
          ),
        );
      },
    );
  }
}
