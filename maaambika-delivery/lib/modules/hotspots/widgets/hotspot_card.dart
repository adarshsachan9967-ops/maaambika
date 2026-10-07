import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/hotspot.dart';

class HotspotCard extends StatelessWidget {
  final Hotspot hotspot;

  const HotspotCard({
    super.key,
    required this.hotspot,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: hotspot.isHot ? const Color(0xFFFEF2F2) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.local_fire_department,
                color: hotspot.isHot ? const Color(0xFFEF4444) : AppConstants.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hotspot.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(hotspot.zone, style: const TextStyle(fontSize: 12, color: AppConstants.textSlate)),
                  const SizedBox(height: 4),
                  Text(hotspot.ordersCount, style: const TextStyle(fontSize: 11, color: AppConstants.textMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.warningBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                hotspot.surge,
                style: const TextStyle(color: Color(0xFFB45309), fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
