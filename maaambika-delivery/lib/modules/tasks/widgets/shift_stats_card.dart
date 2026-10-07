import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class ShiftStatsCard extends StatelessWidget {
  final int activeCount;
  final int completedCount;
  final String estimatedEarnings;
  final String completionPercent;
  final String rating;

  const ShiftStatsCard({
    super.key,
    required this.activeCount,
    required this.completedCount,
    this.estimatedEarnings = '₹1,090',
    this.completionPercent = '68%',
    this.rating = '4.95 ⭐',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Today's Shift", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    '$activeCount Active • $completedCount Done',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withValues(alpha: 0.3),
                  border: Border.all(color: const Color(0xFF3B82F6)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Target: ${AppConstants.defaultDailyTripTarget} Trips',
                  style: const TextStyle(color: Color(0xFF93C5FD), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShiftStat('Est. Earnings', estimatedEarnings, Colors.white),
              Container(width: 1, height: 28, color: Colors.white24),
              _buildShiftStat('Completion', completionPercent, const Color(0xFF34D399)),
              Container(width: 1, height: 28, color: Colors.white24),
              _buildShiftStat('Customer Rating', rating, AppConstants.ratingGold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShiftStat(String label, String val, Color color) {
    return Column(
      children: [
        Text(val, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}
