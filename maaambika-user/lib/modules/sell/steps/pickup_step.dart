import 'package:flutter/material.dart';

class PickupStep extends StatelessWidget {
  final String selectedDate;
  final String selectedSlot;
  final Function(String date) onDateSelected;
  final Function(String slot) onSlotSelected;
  final VoidCallback onConfirm;

  const PickupStep({
    super.key,
    required this.selectedDate,
    required this.selectedSlot,
    required this.onDateSelected,
    required this.onSlotSelected,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Pickup Date & Time Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF059669)),
              title: Text('Pickup Date: $selectedDate'),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () {
                // Show date picker
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.access_time, color: Color(0xFF059669)),
              title: Text('Time Slot: $selectedSlot'),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () {
                // Show slot picker
              },
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: onConfirm,
              child: const Text('Confirm Pickup Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
