import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';

class RentalCatalogView extends StatelessWidget {
  final List<Map<String, dynamic>> rentals;
  final Function(Map<String, dynamic>) onRentalSelected;

  const RentalCatalogView({
    super.key,
    required this.rentals,
    required this.onRentalSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (rentals.isEmpty) {
      return const Center(child: Text('No camera rentals available currently.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rentals.length,
      itemBuilder: (ctx, idx) {
        final r = rentals[idx];
        final title = '${r['brand'] ?? ''} ${r['model'] ?? ''}'.trim();
        final dailyRate = r['dailyRate'] ?? 0;
        final deposit = r['securityDeposit'] ?? 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Verified Gear', style: TextStyle(color: Color(0xFF2563EB), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(r['specs'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${formatCurrency(dailyRate)} / day', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                        Text('Refundable Deposit: ${formatCurrency(deposit)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => onRentalSelected(r),
                      child: const Text('Rent Gear'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
