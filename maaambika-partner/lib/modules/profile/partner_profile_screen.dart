import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/fallback/fallback_partner_data.dart';
import 'bloc/partner_profile_bloc.dart';
import 'bloc/partner_profile_event.dart';
import 'bloc/partner_profile_state.dart';
import 'widgets/profile_item_tile.dart';

class PartnerProfileScreen extends StatelessWidget {
  const PartnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PartnerProfileBloc, PartnerProfileState>(
      listener: (context, state) {
        if (state is PartnerProfileLoggedOutState) {
          Helpers.showSuccessSnackbar('Session Closed', 'Partner session terminated.');
        }
      },
      builder: (context, state) {
        final store = state is PartnerProfileLoadedState
            ? state.store
            : FallbackPartnerData.store;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryColor,
                    child: Icon(Icons.store, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.storeName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'GSTIN: ${store.gstin} ${AppConstants.bulletSymbol} Verified',
                          style: const TextStyle(
                            color: Color(0xFF60A5FA),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          store.address,
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ProfileItemTile(
              icon: Icons.verified,
              iconColor: AppColors.accentColor,
              title: 'Aadhaar & PAN KYC',
              subtitle: 'Govt. Business Identity Approved',
              onTap: () {
                Helpers.showSuccessSnackbar('KYC Status', 'Govt. Business Identity is Approved.');
              },
            ),
            ProfileItemTile(
              icon: Icons.account_balance,
              iconColor: AppColors.primaryColor,
              title: 'Bank Escrow Account',
              subtitle: 'HDFC Bank •••• 4092 (Instant Settlement Enabled)',
              onTap: () {
                Helpers.showSuccessSnackbar('Escrow Bank', 'HDFC Bank •••• 4092 is linked and active.');
              },
            ),
            ProfileItemTile(
              icon: Icons.schedule,
              iconColor: AppColors.goldBadge,
              title: 'Operating Hours',
              subtitle: store.operatingHours,
              onTap: () {
                Helpers.showSuccessSnackbar('Operating Hours', store.operatingHours);
              },
            ),
            ProfileItemTile(
              icon: Icons.logout,
              iconColor: AppColors.errorRed,
              title: 'Sign Out Partner Portal',
              subtitle: 'Clear secure session credentials',
              onTap: () {
                context.read<PartnerProfileBloc>().add(const LogoutPartnerEvent());
              },
            ),
          ],
        );
      },
    );
  }
}
