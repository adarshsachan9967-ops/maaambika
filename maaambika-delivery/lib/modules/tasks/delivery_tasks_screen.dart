import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/delivery_task.dart';
import 'widgets/task_card.dart';

class DeliveryTasksScreen extends StatefulWidget {
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
  State<DeliveryTasksScreen> createState() => _DeliveryTasksScreenState();
}

class _DeliveryTasksScreenState extends State<DeliveryTasksScreen> {
  int _selectedTab = 0; // 0: All, 1: Pickup, 2: In Transit, 3: Completed
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppConstants.primaryColor),
      );
    }

    final pickupCount = widget.tasks.where((t) => t.isAssigned).length;
    final inTransitCount = widget.tasks.where((t) => t.isInTransit).length;
    final completedCount = widget.tasks.where((t) => t.isDelivered).length;

    // Filter tasks
    final filteredTasks = widget.tasks.where((t) {
      if (_selectedTab == 1 && !t.isAssigned) return false;
      if (_selectedTab == 2 && !t.isInTransit) return false;
      if (_selectedTab == 3 && !t.isDelivered) return false;

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchDevice = t.device.toLowerCase().contains(query);
        final matchCustomer = t.customer.toLowerCase().contains(query);
        final matchId = t.id.toLowerCase().contains(query);
        final matchAddr = t.address.toLowerCase().contains(query);
        return matchDevice || matchCustomer || matchId || matchAddr;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ── SEARCH BAR ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val.trim()),
                      decoration: const InputDecoration(
                        hintText: 'Search tasks by ID, device or location...',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    InkWell(
                      onTap: () => setState(() => _searchQuery = ''),
                      child: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 18),
                    ),
                ],
              ),
            ),
          ),

          // ── FILTER TABS (MATCHING DESIGN SCREENSHOT) ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabItem(title: 'All Tasks', index: 0),
                  _buildTabItem(title: 'Pickup ($pickupCount)', index: 1),
                  _buildTabItem(title: 'In Transit ($inTransitCount)', index: 2),
                  _buildTabItem(title: 'Completed ($completedCount)', index: 3),
                ],
              ),
            ),
          ),

          // ── TASKS LIST ──
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.assignment_turned_in_outlined,
                            size: 32,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No tasks in this category',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'New assignments will appear automatically',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        task: filteredTasks[index],
                        onTaskUpdated: widget.onTasksUpdated,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({required String title, required int index}) {
    final isSelected = _selectedTab == index;

    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF059669) : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF059669) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
