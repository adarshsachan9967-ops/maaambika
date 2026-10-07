import 'package:flutter/material.dart';

class PayoutBottomSheet extends StatefulWidget {
  final String currentUpi;
  final String currentBank;
  final Function(String upi, String bank) onSave;

  const PayoutBottomSheet({
    super.key,
    required this.currentUpi,
    required this.currentBank,
    required this.onSave,
  });

  @override
  State<PayoutBottomSheet> createState() => _PayoutBottomSheetState();
}

class _PayoutBottomSheetState extends State<PayoutBottomSheet> {
  late TextEditingController _upiController;
  late TextEditingController _bankController;

  @override
  void initState() {
    super.initState();
    _upiController = TextEditingController(text: widget.currentUpi);
    _bankController = TextEditingController(text: widget.currentBank);
  }

  @override
  void dispose() {
    _upiController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Instant Payout Methods', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('UPI ID (Recommended for instant spot payout):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: _upiController,
            decoration: InputDecoration(
              hintText: 'e.g. yourname@okhdfcbank',
              prefixIcon: const Icon(Icons.flash_on, color: Color(0xFF059669)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 14),
          const Text('Bank Account Number / IFSC:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: _bankController,
            decoration: InputDecoration(
              hintText: 'Account No. + IFSC',
              prefixIcon: const Icon(Icons.account_balance, color: Color(0xFF059669)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                widget.onSave(_upiController.text.trim(), _bankController.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Save Payout Details', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
