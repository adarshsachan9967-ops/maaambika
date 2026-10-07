import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/helpers.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBroadcastPressed;
  final VoidCallback onRefreshPressed;

  const AdminAppBar({
    super.key,
    required this.onBroadcastPressed,
    required this.onRefreshPressed,
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
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.amber, width: 1),
            ),
            child: Image.asset(
              AppConstants.appLogoPath,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => const Icon(
                Icons.shield,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MAA AMBIKA ADMIN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Master Control • Super Admin',
                style: TextStyle(fontSize: 11, color: Color(0xFFA78BFA)),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            onRefreshPressed();
            Helpers.showSuccessSnackbar(
              'Telemetry Sync',
              'Synchronized latest system telemetry!',
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.campaign_outlined),
          onPressed: onBroadcastPressed,
        ),
      ],
    );
  }
}
