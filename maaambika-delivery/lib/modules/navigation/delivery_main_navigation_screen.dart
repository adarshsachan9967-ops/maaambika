import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/delivery_task.dart';
import '../../widgets/delivery_app_bar.dart';
import '../../widgets/delivery_bottom_bar.dart';
import '../dashboard/delivery_home_dashboard_screen.dart';
import '../earnings/delivery_earnings_screen.dart';
import '../profile/delivery_profile_screen.dart';
import '../support/delivery_support_screen.dart';
import '../tasks/bloc/delivery_tasks_bloc.dart';
import '../tasks/bloc/delivery_tasks_event.dart';
import '../tasks/bloc/delivery_tasks_state.dart';
import '../tasks/delivery_tasks_screen.dart';

class DeliveryMainNavigationScreen extends StatefulWidget {
  const DeliveryMainNavigationScreen({super.key});

  @override
  State<DeliveryMainNavigationScreen> createState() => _DeliveryMainNavigationScreenState();
}

class _DeliveryMainNavigationScreenState extends State<DeliveryMainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeliveryTasksBloc()..add(const LoadDeliveryTasksEvent()),
      child: BlocBuilder<DeliveryTasksBloc, DeliveryTasksState>(
        builder: (context, state) {
          final isOnline = state is DeliveryTasksLoaded ? state.isOnline : true;
          final List<DeliveryTask> tasks =
              state is DeliveryTasksLoaded ? state.tasks : <DeliveryTask>[];
          final isLoading = state is DeliveryTasksLoading;

          return Scaffold(
            appBar: DeliveryAppBar(
              isOnline: isOnline,
              onOnlineChanged: (val) {
                context.read<DeliveryTasksBloc>().add(ToggleDutyStatusEvent(val));
              },
            ),
            body: IndexedStack(
              index: _currentIndex,
              children: [
                DeliveryHomeDashboardScreen(
                  tasks: tasks,
                  isOnline: isOnline,
                  onViewAllTasks: () => setState(() => _currentIndex = 1),
                  onTasksUpdated: () {
                    context.read<DeliveryTasksBloc>().add(const LoadDeliveryTasksEvent());
                  },
                  onNavigateTab: (idx) => setState(() => _currentIndex = idx),
                ),
                DeliveryTasksScreen(
                  tasks: tasks,
                  isLoading: isLoading,
                  onTasksUpdated: () {
                    context.read<DeliveryTasksBloc>().add(const LoadDeliveryTasksEvent());
                  },
                ),
                const DeliveryEarningsScreen(),
                const DeliverySupportScreen(),
                const DeliveryProfileScreen(),
              ],
            ),
            bottomNavigationBar: DeliveryBottomBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
            ),
          );
        },
      ),
    );
  }
}
