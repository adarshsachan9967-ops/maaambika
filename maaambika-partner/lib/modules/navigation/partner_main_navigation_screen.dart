import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/fallback/fallback_partner_data.dart';
import '../../widgets/partner_app_bar.dart';
import '../../widgets/partner_bottom_bar.dart';
import '../dashboard/bloc/partner_dashboard_bloc.dart';
import '../dashboard/bloc/partner_dashboard_event.dart';
import '../dashboard/partner_dashboard_screen.dart';
import '../inspection/bloc/partner_inspection_bloc.dart';
import '../inspection/partner_inspection_screen.dart';
import '../orders/bloc/partner_orders_bloc.dart';
import '../orders/bloc/partner_orders_event.dart';
import '../orders/partner_orders_screen.dart';
import '../payouts/bloc/partner_payouts_bloc.dart';
import '../payouts/partner_payouts_screen.dart';
import '../profile/bloc/partner_profile_bloc.dart';
import '../profile/bloc/partner_profile_event.dart';
import '../profile/partner_profile_screen.dart';

class PartnerMainNavigationScreen extends StatefulWidget {
  const PartnerMainNavigationScreen({super.key});

  @override
  State<PartnerMainNavigationScreen> createState() => _PartnerMainNavigationScreenState();
}

class _PartnerMainNavigationScreenState extends State<PartnerMainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PartnerDashboardBloc>(
          create: (ctx) => PartnerDashboardBloc()..add(const LoadPartnerDashboardEvent()),
        ),
        BlocProvider<PartnerOrdersBloc>(
          create: (ctx) => PartnerOrdersBloc()..add(const LoadPartnerOrdersEvent()),
        ),
        BlocProvider<PartnerInspectionBloc>(
          create: (ctx) => PartnerInspectionBloc(),
        ),
        BlocProvider<PartnerPayoutsBloc>(
          create: (ctx) => PartnerPayoutsBloc(),
        ),
        BlocProvider<PartnerProfileBloc>(
          create: (ctx) => PartnerProfileBloc()..add(const LoadPartnerProfileEvent()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: PartnerAppBar(
              store: FallbackPartnerData.store,
              onRefresh: () {
                context.read<PartnerDashboardBloc>().add(
                      const LoadPartnerDashboardEvent(isRefresh: true),
                    );
                context.read<PartnerOrdersBloc>().add(
                      const LoadPartnerOrdersEvent(isRefresh: true),
                    );
                context.read<PartnerProfileBloc>().add(
                      const LoadPartnerProfileEvent(isRefresh: true),
                    );
              },
            ),
            body: IndexedStack(
              index: _currentIndex,
              children: [
                PartnerDashboardScreen(onNavigate: (idx) => setState(() => _currentIndex = idx)),
                const PartnerOrdersScreen(),
                const PartnerInspectionScreen(),
                const PartnerPayoutsScreen(),
                const PartnerProfileScreen(),
              ],
            ),
            bottomNavigationBar: PartnerBottomBar(
              selectedIndex: _currentIndex,
              onItemSelected: (idx) => setState(() => _currentIndex = idx),
            ),
          );
        },
      ),
    );
  }
}
