import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/helpers.dart';
import 'bloc/partners_bloc.dart';
import 'bloc/partners_event.dart';
import 'bloc/partners_state.dart';
import 'widgets/partner_store_card.dart';

class AdminPartnersScreen extends StatelessWidget {
  const AdminPartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PartnersBloc, PartnersState>(
      listener: (context, state) {
        if (state is PartnersLoadedState && state.message != null) {
          Helpers.showSuccessSnackbar('Partner Approved', state.message!);
        }
      },
      builder: (context, state) {
        if (state is PartnersLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final partners = state is PartnersLoadedState ? state.partners : [];

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context.read<PartnersBloc>().add(const LoadPartnersEvent(isRefresh: true));
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
                      'Registered Partner Stores',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '${partners.length} stores',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (partners.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No partner stores registered yet',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    ),
                  )
                else
                  ...partners.map(
                    (p) => PartnerStoreCard(
                      partner: p,
                      onApproveKyc: () {
                        context.read<PartnersBloc>().add(
                              ApproveKycEvent(partnerName: p.name),
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
