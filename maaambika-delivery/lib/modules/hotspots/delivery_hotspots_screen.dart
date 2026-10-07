import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import 'bloc/hotspots_bloc.dart';
import 'bloc/hotspots_event.dart';
import 'bloc/hotspots_state.dart';
import 'widgets/hotspot_card.dart';
import 'widgets/hub_card.dart';

class DeliveryHotspotsScreen extends StatelessWidget {
  const DeliveryHotspotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotspotsBloc()..add(const LoadHotspotsEvent()),
      child: BlocBuilder<HotspotsBloc, HotspotsState>(
        builder: (context, state) {
          if (state is HotspotsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppConstants.primaryColor),
            );
          }

          if (state is HotspotsError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: AppConstants.errorRed),
              ),
            );
          }

          if (state is HotspotsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'High-Demand Pickup Zones',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Move closer to these areas for instant order assignments with surge pricing.',
                    style: TextStyle(fontSize: 12, color: AppConstants.textSlate),
                  ),
                  const SizedBox(height: 16),
                  ...state.hotspots.map((spot) => HotspotCard(hotspot: spot)),
                  const SizedBox(height: 20),
                  const Text(
                    'Official Maa Ambika Drop-off Hubs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...state.hubs.map((hub) => HubCard(hub: hub)),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
