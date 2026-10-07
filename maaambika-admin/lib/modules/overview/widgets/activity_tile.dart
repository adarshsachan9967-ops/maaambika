import 'package:flutter/material.dart';
import '../../../../data/models/audit_activity.dart';

class ActivityTile extends StatelessWidget {
  final AuditActivity activity;

  const ActivityTile({
    super.key,
    required this.activity,
  });

  IconData _getIcon() {
    switch (activity.type) {
      case 'rider':
        return Icons.two_wheeler;
      case 'payout':
        return Icons.check_circle;
      case 'pricing':
        return Icons.edit_note;
      case 'order':
      default:
        return Icons.add_shopping_cart;
    }
  }

  Color _getColor() {
    switch (activity.type) {
      case 'rider':
        return const Color(0xFF7C3AED);
      case 'payout':
        return const Color(0xFF10B981);
      case 'pricing':
        return const Color(0xFFF59E0B);
      case 'order':
      default:
        return const Color(0xFF2563EB);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final icon = _getIcon();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 16),
        ),
        title: Text(
          activity.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Text(
          activity.description,
          style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
        ),
        trailing: Text(
          activity.time,
          style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
        ),
      ),
    );
  }
}
