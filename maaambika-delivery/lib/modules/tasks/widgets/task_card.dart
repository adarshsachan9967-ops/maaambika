import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/delivery_task.dart';
import 'inspection_bottom_sheet.dart';

class TaskCard extends StatelessWidget {
  final DeliveryTask task;
  final VoidCallback onTaskUpdated;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final isDelivered = task.isDelivered;
    final isInTransit = task.isInTransit;
    final badgeColor = task.statusBadgeColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    task.type,
                    style: TextStyle(color: badgeColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDelivered ? const Color(0xFFDCFCE7) : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.status,
                    style: TextStyle(
                      color: isDelivered ? AppConstants.successGreenDark : const Color(0xFF1D4ED8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Order ID & Device
            Text(
              task.id,
              style: const TextStyle(fontSize: 13, color: AppConstants.textSlate, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              task.device,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.textDark),
            ),
            const SizedBox(height: 2),
            Text(
              task.condition,
              style: const TextStyle(fontSize: 12, color: AppConstants.textMuted),
            ),
            const SizedBox(height: 10),

            // Customer details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.surfaceColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppConstants.borderSlate),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: AppConstants.textSlate),
                      const SizedBox(width: 8),
                      Text(
                        task.customer,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                      ),
                      const Spacer(),
                      Text(task.timeSlot, style: const TextStyle(fontSize: 11, color: AppConstants.textSlate)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.place, size: 16, color: Color(0xFFEF4444)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task.address,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.near_me, size: 14, color: AppConstants.primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            task.distance,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Rider Fee: ${task.feeEarned}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Quick actions or delivered status
            if (!isDelivered) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.call, size: 16, color: AppConstants.primaryColor),
                      label: const Text('Call Customer', style: TextStyle(color: AppConstants.primaryColor, fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppConstants.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Helpers.makePhoneCall(task.phone);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.navigation, size: 16, color: AppConstants.secondaryColor),
                      label: const Text('Navigate (Maps)', style: TextStyle(color: AppConstants.secondaryColor, fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppConstants.secondaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Helpers.openMapAddress(task.address);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(isInTransit ? Icons.verified : Icons.play_arrow, color: Colors.white, size: 18),
                  label: Text(
                    isInTransit ? 'Verify & Complete Delivery' : 'Start Task / Inspect Device',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInTransit ? AppConstants.secondaryColor : AppConstants.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    InspectionBottomSheet.show(
                      context,
                      task: task,
                      onTaskCompleted: () {
                        task.status = 'Delivered';
                        onTaskUpdated();
                      },
                    );
                  },
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Successfully verified & completed',
                        style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
