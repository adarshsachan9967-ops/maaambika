import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../data/fallback/fallback_partner_data.dart';
import 'bloc/partner_orders_bloc.dart';
import 'bloc/partner_orders_event.dart';
import 'bloc/partner_orders_state.dart';
import 'widgets/order_tile.dart';

class PartnerOrdersScreen extends StatelessWidget {
  const PartnerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnerOrdersBloc, PartnerOrdersState>(
      builder: (context, state) {
        if (state is PartnerOrdersLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final orders = state is PartnerOrdersLoadedState
            ? state.orders
            : FallbackPartnerData.orders;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context.read<PartnerOrdersBloc>().add(
                  const LoadPartnerOrdersEvent(isRefresh: true),
                );
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Partner Orders Dispatch',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Live orders assigned to your store for walk-in and hub drops.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              if (orders.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No active orders found.',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
                )
              else
                ...orders.map((order) => OrderTile(order: order)),
            ],
          ),
        );
      },
    );
  }
}
