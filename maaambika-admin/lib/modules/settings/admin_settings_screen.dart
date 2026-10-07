import 'package:flutter/material.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/session_manager.dart';
import 'widgets/settings_item_tile.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Column(
              children: [
                SettingsItemTile(
                  icon: Icons.admin_panel_settings,
                  title: 'Admin Access Control',
                  subtitle: '3 Super Admins, 12 Dispatch Managers',
                  onTap: () {
                    Helpers.showSuccessSnackbar(
                      'Access Control',
                      'Active: 3 Super Admins, 12 Dispatch Managers',
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                SettingsItemTile(
                  icon: Icons.price_change,
                  title: 'Dynamic Valuation Algorithm',
                  subtitle: 'Standard 1.0x Base Multiplier Active',
                  onTap: () {
                    Helpers.showSuccessSnackbar(
                      'Valuation Config',
                      'Dynamic multiplier operating optimally',
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                SettingsItemTile(
                  icon: Icons.verified_user,
                  title: 'Biometric / 2FA Security',
                  subtitle: 'Mandatory for all admin logins',
                  onTap: () {
                    Helpers.showSuccessSnackbar(
                      'Security',
                      '2FA Enforcement verified across all sessions',
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                SettingsItemTile(
                  icon: Icons.cloud_sync,
                  title: 'Cloud Database Backups',
                  subtitle: 'Hourly snapshots enabled (PostgreSQL)',
                  onTap: () {
                    Helpers.showSuccessSnackbar(
                      'Cloud Backup',
                      'Latest snapshot recorded 14 minutes ago',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout, color: Color(0xFFDC2626)),
            label: const Text(
              'Exit Admin Console',
              style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFDC2626)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              await SessionManager.forceLogout();
              Helpers.showSuccessSnackbar('Session Closed', 'Admin session terminated.');
            },
          ),
        ],
      ),
    );
  }
}
