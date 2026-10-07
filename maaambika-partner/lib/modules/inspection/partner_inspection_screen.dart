import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/helpers.dart';
import 'bloc/partner_inspection_bloc.dart';
import 'bloc/partner_inspection_event.dart';
import 'bloc/partner_inspection_state.dart';

class PartnerInspectionScreen extends StatelessWidget {
  const PartnerInspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PartnerInspectionBloc, PartnerInspectionState>(
      listener: (context, state) {
        if (state is PartnerInspectionSuccessState) {
          Helpers.showSuccessSnackbar('Offer Accepted', state.successMessage);
        }
      },
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              '45-Point Device Inspection Desk',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Apple iPhone 14 Pro 128GB ${AppConstants.bulletSymbol} IMEI: 354891028472911',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Live Valuation Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FINAL CALCULATED OFFER',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Based on instant inspection checks',
                        style: TextStyle(color: Colors.black54, fontSize: 11),
                      ),
                    ],
                  ),
                  Text(
                    formatCurrency(state.calculatedOffer),
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Hardware & Diagnostic Toggles',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildToggleTile(
              context,
              'touchScreen',
              'Display & Touchscreen',
              'No scratches, OEM Super Retina OLED responsive',
              state.touchScreen,
            ),
            _buildToggleTile(
              context,
              'cameras',
              'Camera Sensors & Flash',
              'Primary, ultrawide and telephoto autofocus working',
              state.cameras,
            ),
            _buildToggleTile(
              context,
              'battery',
              'Battery Health > 82%',
              'Optimal peak performance capability',
              state.battery,
            ),
            _buildToggleTile(
              context,
              'biometrics',
              'FaceID / Biometrics',
              'TrueDepth camera and FaceID sensor functional',
              state.biometrics,
            ),
            _buildToggleTile(
              context,
              'bodyFlawless',
              'Chassis & Back Glass',
              'No dents, frame bends or shattered glass',
              state.bodyFlawless,
            ),
            _buildToggleTile(
              context,
              'boxAndBill',
              'Original Box & GST Invoice',
              'Matching serial box with official purchase bill',
              state.boxAndBill,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                context.read<PartnerInspectionBloc>().add(const SubmitInspectionEvent());
              },
              child: const Text(
                'Customer Acceptance & Instant Payout',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggleTile(
    BuildContext context,
    String key,
    String title,
    String subtitle,
    bool value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        value: value,
        activeThumbColor: AppColors.accentColor,
        onChanged: (val) {
          context.read<PartnerInspectionBloc>().add(
                ToggleChecklistEvent(key: key, value: val),
              );
        },
      ),
    );
  }
}
