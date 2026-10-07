import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/delivery_task.dart';
import 'otp_verification_dialog.dart';

class InspectionBottomSheet extends StatefulWidget {
  final DeliveryTask task;
  final VoidCallback onTaskCompleted;

  const InspectionBottomSheet({
    super.key,
    required this.task,
    required this.onTaskCompleted,
  });

  static void show(
    BuildContext context, {
    required DeliveryTask task,
    required VoidCallback onTaskCompleted,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => InspectionBottomSheet(
        task: task,
        onTaskCompleted: onTaskCompleted,
      ),
    );
  }

  @override
  State<InspectionBottomSheet> createState() => _InspectionBottomSheetState();
}

class _InspectionBottomSheetState extends State<InspectionBottomSheet> {
  static const List<String> checklistTitles = [
    'Physical Screen & Display (No cracks, touch works)',
    'Camera & Flash test (Front & Back sensors ok)',
    'Biometrics & Battery health verification',
    'Device unlocked & iCloud / Google account removed',
  ];

  @override
  Widget build(BuildContext context) {
    final checks = widget.task.checks;
    final allChecked = checks.isNotEmpty && checks.every((c) => c);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Handover Inspection: ${widget.task.id}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.task.device, style: const TextStyle(fontSize: 12, color: AppConstants.textSlate)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Mandatory Inspection Checklist:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppConstants.textDark),
            ),
            const SizedBox(height: 10),
            ...List.generate(checklistTitles.length, (chkIdx) {
              return CheckboxListTile(
                value: chkIdx < checks.length ? checks[chkIdx] : false,
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: AppConstants.secondaryColor,
                title: Text(checklistTitles[chkIdx], style: const TextStyle(fontSize: 13)),
                onChanged: (val) {
                  setState(() {
                    if (chkIdx < checks.length) {
                      checks[chkIdx] = val ?? false;
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.warningBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security, color: Color(0xFFB45309), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Customer Payout: ${widget.task.payoutToCustomer}. Hand over funds or collect cash only after OTP check.',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: allChecked ? AppConstants.secondaryColor : const Color(0xFF94A3B8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: allChecked
                    ? () {
                        Navigator.pop(context);
                        OtpVerificationDialog.show(
                          context,
                          task: widget.task,
                          onVerified: widget.onTaskCompleted,
                        );
                      }
                    : null,
                child: const Text(
                  'Proceed to OTP Handover Verification',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
