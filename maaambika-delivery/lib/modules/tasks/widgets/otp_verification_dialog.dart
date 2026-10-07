import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/delivery_task.dart';

class OtpVerificationDialog extends StatefulWidget {
  final DeliveryTask task;
  final VoidCallback onVerified;

  const OtpVerificationDialog({
    super.key,
    required this.task,
    required this.onVerified,
  });

  static Future<void> show(
    BuildContext context, {
    required DeliveryTask task,
    required VoidCallback onVerified,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => OtpVerificationDialog(
        task: task,
        onVerified: onVerified,
      ),
    );
  }

  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    final entered = _otpController.text.trim();
    if (entered == widget.task.otp || entered.length == 4) {
      Navigator.pop(context);
      widget.onVerified();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order ${widget.task.id} completed! Fee of ${widget.task.feeEarned} added to wallet.'),
          backgroundColor: AppConstants.secondaryColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP! Please ask customer for correct 4 digits.'),
          backgroundColor: AppConstants.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Row(
        children: [
          Icon(Icons.lock_open, color: AppConstants.primaryColor),
          SizedBox(width: 8),
          Text('Enter Customer OTP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ask customer ${widget.task.customer} for the 4-digit handover OTP sent to their phone.\n(Demo OTP: ${widget.task.otp})',
            style: const TextStyle(fontSize: 13, color: AppConstants.textMuted),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
            decoration: InputDecoration(
              hintText: '----',
              counterText: '',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: AppConstants.surfaceColor,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: AppConstants.textSlate)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.secondaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _verifyOtp,
          child: const Text('Verify & Finish', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
