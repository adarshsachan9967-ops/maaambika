import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/helpers.dart';
import 'bloc/admin_orders_bloc.dart';
import 'bloc/admin_orders_event.dart';
import 'bloc/admin_orders_state.dart';
import 'widgets/admin_order_card.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminOrdersBloc, AdminOrdersState>(
      listener: (context, state) {
        if (state is AdminOrdersLoadedState && state.message != null) {
          Helpers.showSuccessSnackbar('Order Dispatched', state.message!);
        }
      },
      builder: (context, state) {
        if (state is AdminOrdersLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final orders = state is AdminOrdersLoadedState ? state.orders : [];

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context.read<AdminOrdersBloc>().add(const LoadAdminOrdersEvent(isRefresh: true));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Orders & Fulfillment Hub',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '${orders.length} active',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (orders.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No active orders at this time',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    ),
                  )
                else
                  ...orders.map(
                    (o) => AdminOrderCard(
                      order: o,
                      onAssignRider: () {
                        context.read<AdminOrdersBloc>().add(
                              AssignRiderEvent(
                                orderId: o.id,
                                riderId: 'RD-8842',
                                riderName: 'Rahul Sharma',
                              ),
                            );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
