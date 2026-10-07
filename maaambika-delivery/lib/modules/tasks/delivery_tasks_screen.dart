import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/delivery_task.dart';
import 'widgets/shift_stats_card.dart';
import 'widgets/task_card.dart';

class DeliveryTasksScreen extends StatelessWidget {
  final List<DeliveryTask> tasks;
  final VoidCallback onTasksUpdated;
  final bool isLoading;

  const DeliveryTasksScreen({
    super.key,
    required this.tasks,
    required this.onTasksUpdated,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppConstants.primaryColor),
      );
    }

    final activeCount = tasks.where((t) => !t.isDelivered).length;
    final completedCount = tasks.where((t) => t.isDelivered).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats Banner
          ShiftStatsCard(
            activeCount: activeCount,
            completedCount: completedCount,
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Assigned Pickups & Deliveries',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.textDark),
              ),
              Text(
                '${tasks.length} total',
                style: const TextStyle(fontSize: 13, color: AppConstants.textSlate),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tasks List
          if (tasks.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Icon(Icons.inbox_outlined, size: 48, color: AppConstants.textSlate),
                  SizedBox(height: 12),
                  Text('No tasks assigned currently', style: TextStyle(color: AppConstants.textSlate)),
                ],
              ),
            )
          else
            ...tasks.map(
              (task) => TaskCard(
                task: task,
                onTaskUpdated: onTasksUpdated,
              ),
            ),
        ],
      ),
    );
  }
}
