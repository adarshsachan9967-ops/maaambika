import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import 'notifications_modal.dart';

class DeliveryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isOnline;
  final ValueChanged<bool> onOnlineChanged;

  const DeliveryAppBar({
    super.key,
    required this.isOnline,
    required this.onOnlineChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppConstants.appBarDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppConstants.warningAmber, width: 1),
            ),
            child: Image.asset(
              AppConstants.appLogoPath,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => const Icon(Icons.two_wheeler, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppConstants.fleetTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
              ),
              Text(
                isOnline ? 'Online • Ready for Orders' : 'Offline • Duty Paused',
                style: TextStyle(
                  fontSize: 11,
                  color: isOnline ? const Color(0xFF34D399) : Colors.white60,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: isOnline,
            activeThumbColor: AppConstants.successGreen,
            onChanged: (val) {
              onOnlineChanged(val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(val ? 'You are now ONLINE and visible for dispatch!' : 'You are now OFFLINE.'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: val ? AppConstants.secondaryColor : const Color(0xFF475569),
                ),
              );
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => NotificationsModal.show(context),
        ),
      ],
    );
  }
}
