import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class ProfileItemTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isVerified;

  const ProfileItemTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isVerified = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppConstants.textSlate)),
      trailing: isVerified ? const Icon(Icons.check_circle, color: AppConstants.successGreen, size: 18) : null,
    );
  }
}
