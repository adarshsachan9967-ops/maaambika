import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';
import 'widgets/profile_item_tile.dart';

class DeliveryProfileScreen extends StatelessWidget {
  const DeliveryProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(const LoadProfileEvent()),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final profile = state is ProfileLoaded
              ? state.profile
              : null;

          final name = profile?.name ?? AppConstants.demoRiderName;
          final riderId = profile?.riderId ?? AppConstants.demoRiderId;
          final rating = profile?.rating ?? 4.95;
          final vehicle = profile?.vehicle ?? 'Honda Activa 6G (KA-01-EQ-9812)';
          final license = profile?.license ?? 'DL-KA-20190038841 (Valid)';
          final bank = profile?.bank ?? 'HDFC Bank ending in **8491';
          final insurance = profile?.insurance ?? 'Maa Ambika Transit Cover Active (₹5 Lakh)';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppConstants.primaryColor,
                        child: Text(
                          'RS',
                          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Delivery Rider ID: $riderId',
                        style: const TextStyle(fontSize: 12, color: AppConstants.textSlate),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppConstants.successGreen),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.verified, color: AppConstants.secondaryColor, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'KYC Verified Rider',
                                  style: TextStyle(color: AppConstants.secondaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppConstants.warningBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: AppConstants.warningAmber, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '$rating Rating',
                                  style: const TextStyle(color: Color(0xFF92400E), fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Vehicle & Documents
                Card(
                  child: Column(
                    children: [
                      ProfileItemTile(
                        icon: Icons.two_wheeler,
                        title: 'Vehicle Registered',
                        subtitle: vehicle,
                        isVerified: true,
                      ),
                      const Divider(height: 1, indent: 56),
                      ProfileItemTile(
                        icon: Icons.badge,
                        title: 'Driving License',
                        subtitle: license,
                        isVerified: true,
                      ),
                      const Divider(height: 1, indent: 56),
                      ProfileItemTile(
                        icon: Icons.account_balance,
                        title: 'Bank Account for Payouts',
                        subtitle: bank,
                        isVerified: true,
                      ),
                      const Divider(height: 1, indent: 56),
                      ProfileItemTile(
                        icon: Icons.health_and_safety,
                        title: 'Rider Insurance Policy',
                        subtitle: insurance,
                        isVerified: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // SOS Emergency button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.emergency, color: Colors.white),
                    label: const Text(
                      'RIDER SOS / EMERGENCY DISPATCH',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.errorRed,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('SOS Alert sent to Maa Ambika Safety Center & Local Dispatch!'),
                          backgroundColor: AppConstants.errorRed,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: AppConstants.textSlate),
                  label: const Text('Log Out Shift', style: TextStyle(color: AppConstants.textSlate)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rider shift logged out successfully.')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
