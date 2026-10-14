import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/delivery_task.dart';
import 'inspection_bottom_sheet.dart';
import 'otp_verification_dialog.dart';

class TaskCard extends StatelessWidget {
  final DeliveryTask task;
  final VoidCallback onTaskUpdated;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTaskUpdated,
  });

  void _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchMaps(String address) async {
    final encoded = Uri.encodeComponent(address);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _getDeviceAsset(String deviceName) {
    final lower = deviceName.toLowerCase();
    if (lower.contains('s24') || lower.contains('samsung')) {
      return 'assets/images/refurbished/galaxy-s24-ultra.png';
    } else if (lower.contains('oneplus')) {
      return 'assets/images/refurbished/oneplus-12.png';
    } else if (lower.contains('macbook')) {
      return 'assets/images/refurbished/macbook-air-m2.png';
    }
    return 'assets/images/refurbished/iphone-15-pro.png';
  }

  @override
  Widget build(BuildContext context) {
    final isDelivered = task.isDelivered;
    final isInTransit = task.isInTransit;

    // Status chip styling matching reference image
    Color statusBg;
    Color statusText;
    String statusLabel;

    if (isDelivered) {
      statusBg = const Color(0xFFD1FAE5);
      statusText = const Color(0xFF065F46);
      statusLabel = 'Completed';
    } else if (isInTransit) {
      statusBg = const Color(0xFFDBEAFE);
      statusText = const Color(0xFF1E40AF);
      statusLabel = 'In Transit';
    } else {
      statusBg = const Color(0xFFFEF3C7);
      statusText = const Color(0xFFB45309);
      statusLabel = 'Scheduled';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device Image Thumbnail
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Image.asset(
                  _getDeviceAsset(task.device),
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.smartphone_rounded,
                    color: Color(0xFF64748B),
                    size: 34,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Task Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#${task.id}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              color: statusText,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.device,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, color: Color(0xFF64748B), size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            task.customer,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF334155),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () => _launchPhone(task.phone),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.phone_rounded, color: Color(0xFF059669), size: 16),
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 18),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Color(0xFF64748B), size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            task.address,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, color: Color(0xFF64748B), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          task.timeSlot.isNotEmpty ? task.timeSlot : '10:00 AM – 1:00 PM',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Action Buttons: Left GPS Maps & Right Primary Action
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _launchMaps(task.address),
                  icon: const Icon(Icons.navigation_outlined, size: 16, color: Color(0xFF0F766E)),
                  label: const Text(
                    'GPS Maps',
                    style: TextStyle(
                      color: Color(0xFF0F766E),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0FDFA),
                    side: const BorderSide(color: Color(0xFFCCFBF1)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (isDelivered) {
                      _showDetailsDialog(context);
                    } else if (isInTransit) {
                      InspectionBottomSheet.show(
                        context,
                        task: task,
                        onTaskCompleted: () {
                          OtpVerificationDialog.show(
                            context,
                            task: task,
                            onVerified: onTaskUpdated,
                          );
                        },
                      );
                    } else {
                      // Move to in transit or start pickup
                      task.status = 'In Transit';
                      onTaskUpdated();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pickup started! Navigating to customer location.'),
                          backgroundColor: Color(0xFF059669),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    isDelivered
                        ? Icons.check_circle_outline
                        : isInTransit
                            ? Icons.assignment_turned_in_outlined
                            : Icons.phone_in_talk_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    isDelivered
                        ? 'Completed'
                        : isInTransit
                            ? 'Update Status'
                            : 'Start Pickup',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Task #${task.id}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Delivered',
                    style: TextStyle(color: Color(0xFF065F46), fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Device: ${task.device}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Customer: ${task.customer} (${task.phone})', style: const TextStyle(color: Color(0xFF475569))),
            const SizedBox(height: 4),
            Text('Address: ${task.address}', style: const TextStyle(color: Color(0xFF475569))),
            const SizedBox(height: 4),
            Text('Fee Earned: ₹${task.feeEarned}', style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669)),
                child: const Text('Close', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
