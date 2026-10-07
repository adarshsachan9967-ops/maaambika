import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';

class ImeiVerificationSheet extends StatefulWidget {
  final Function(String imei) onVerified;

  const ImeiVerificationSheet({
    super.key,
    required this.onVerified,
  });

  @override
  State<ImeiVerificationSheet> createState() => _ImeiVerificationSheetState();
}

class _ImeiVerificationSheetState extends State<ImeiVerificationSheet> {
  final TextEditingController _imeiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _imeiController.dispose();
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Device Verification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter device 15-digit IMEI or Serial number to guarantee verified payout rate.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imeiController,
              keyboardType: TextInputType.number,
              validator: Validators.validateImei,
              decoration: InputDecoration(
                hintText: 'Enter 15-digit IMEI number',
                prefixIcon: const Icon(Icons.pin, color: Color(0xFF059669)),
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
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onVerified(_imeiController.text.trim());
                    Navigator.pop(context);
                  }
                },
                child: const Text('Verify & Proceed', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
