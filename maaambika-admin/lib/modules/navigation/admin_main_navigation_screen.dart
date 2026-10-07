import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_bottom_bar.dart';
import '../marketing/bloc/marketing_bloc.dart';
import '../marketing/bloc/marketing_event.dart';
import '../marketing/widgets/broadcast_composer_dialog.dart';
import '../orders/bloc/admin_orders_bloc.dart';
import '../orders/bloc/admin_orders_event.dart';
import '../overview/bloc/overview_bloc.dart';
import '../overview/bloc/overview_event.dart';
import '../partners/bloc/partners_bloc.dart';
import '../partners/bloc/partners_event.dart';
import '../overview/admin_overview_screen.dart';
import '../orders/admin_orders_screen.dart';
import '../partners/admin_partners_screen.dart';
import '../marketing/admin_marketing_screen.dart';
import '../settings/admin_settings_screen.dart';

class AdminMainNavigationScreen extends StatefulWidget {
  const AdminMainNavigationScreen({super.key});

  @override
  State<AdminMainNavigationScreen> createState() => _AdminMainNavigationScreenState();
}

class _AdminMainNavigationScreenState extends State<AdminMainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OverviewBloc>(
          create: (ctx) => OverviewBloc()..add(const LoadOverviewEvent()),
        ),
        BlocProvider<AdminOrdersBloc>(
          create: (ctx) => AdminOrdersBloc()..add(const LoadAdminOrdersEvent()),
        ),
        BlocProvider<PartnersBloc>(
          create: (ctx) => PartnersBloc()..add(const LoadPartnersEvent()),
        ),
        BlocProvider<MarketingBloc>(
          create: (ctx) => MarketingBloc()..add(const LoadMarketingEvent()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AdminAppBar(
              onBroadcastPressed: () {
                BroadcastComposerDialog.show(context, (title, body) {
                  context.read<MarketingBloc>().add(
                        DispatchBroadcastEvent(title: title, body: body),
                      );
                });
              },
              onRefreshPressed: () {
                context.read<OverviewBloc>().add(const LoadOverviewEvent(isRefresh: true));
                context.read<AdminOrdersBloc>().add(const LoadAdminOrdersEvent(isRefresh: true));
                context.read<PartnersBloc>().add(const LoadPartnersEvent(isRefresh: true));
                context.read<MarketingBloc>().add(const LoadMarketingEvent(isRefresh: true));
              },
            ),
            body: IndexedStack(
              index: _currentIndex,
              children: [
                AdminOverviewScreen(
                  onReviewPartners: () {
                    setState(() => _currentIndex = 2); // Switch to partners tab
                  },
                ),
                const AdminOrdersScreen(),
                const AdminPartnersScreen(),
                const AdminMarketingScreen(),
                const AdminSettingsScreen(),
              ],
            ),
            bottomNavigationBar: AdminBottomBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
            ),
          );
        },
      ),
    );
  }
}
