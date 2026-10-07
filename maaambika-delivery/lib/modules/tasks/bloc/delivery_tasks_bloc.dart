import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/fallback/fallback_delivery_data.dart';
import '../../../data/models/delivery_task.dart';
import '../models/requests/update_task_status_request.dart';
import '../models/responses/tasks_response.dart';
import '../repositories/tasks_repository.dart';
import 'delivery_tasks_event.dart';
import 'delivery_tasks_state.dart';

class DeliveryTasksBloc extends Bloc<DeliveryTasksEvent, DeliveryTasksState> {
  final TasksRepository repository;

  DeliveryTasksBloc({TasksRepository? repository})
      : repository = repository ?? TasksRepositoryImpl(),
        super(const DeliveryTasksInitial()) {
    on<LoadDeliveryTasksEvent>(_onLoadTasks);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
    on<CompleteDeliveryTaskEvent>(_onCompleteTask);
    on<ToggleDutyStatusEvent>(_onToggleDutyStatus);
  }

  Future<void> _onLoadTasks(
    LoadDeliveryTasksEvent event,
    Emitter<DeliveryTasksState> emit,
  ) async {
    emit(const DeliveryTasksLoading());
    try {
      List<DeliveryTask> tasks = [];
      try {
        final response = await repository.getTasks();
        if (response.statusCode == 200 && response.data != null) {
          final tasksResponse = TasksResponse.fromJson(response.data);
          if (tasksResponse.tasks.isNotEmpty) {
            tasks = tasksResponse.tasks;
          }
        }
      } catch (networkError) {
        if (kDebugMode) {
          debugPrint('DeliveryTasksBloc: API error ($networkError), loading fallback.');
        }
      }

      if (tasks.isEmpty) {
        tasks = FallbackDeliveryData.getInitialTasks();
      }

      final storage = await StorageService.getInstance();
      final isOnline = storage.getBool(AppKeys.isOnline) ?? true;

      emit(DeliveryTasksLoaded(tasks: tasks, isOnline: isOnline));
    } catch (e) {
      emit(DeliveryTasksError('Failed to load tasks: $e'));
    }
  }

  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatusEvent event,
    Emitter<DeliveryTasksState> emit,
  ) async {
    if (state is DeliveryTasksLoaded) {
      final currentState = state as DeliveryTasksLoaded;
      final updatedTasks = currentState.tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(status: event.newStatus);
        }
        return task;
      }).toList();

      emit(currentState.copyWith(tasks: updatedTasks));

      try {
        await repository.updateTaskStatus(
          UpdateTaskStatusRequest(taskId: event.taskId, status: event.newStatus),
        );
      } catch (_) {}
    }
  }

  Future<void> _onCompleteTask(
    CompleteDeliveryTaskEvent event,
    Emitter<DeliveryTasksState> emit,
  ) async {
    if (state is DeliveryTasksLoaded) {
      final currentState = state as DeliveryTasksLoaded;
      final updatedTasks = currentState.tasks.map((task) {
        if (task.id == event.taskId) {
          final completedChecks = List<bool>.filled(task.checks.length, true);
          return task.copyWith(status: 'Delivered', checks: completedChecks);
        }
        return task;
      }).toList();

      emit(currentState.copyWith(
        tasks: updatedTasks,
        message: 'Order ${event.taskId} completed successfully!',
      ));

      try {
        await repository.updateTaskStatus(
          UpdateTaskStatusRequest(taskId: event.taskId, status: 'Delivered'),
        );
      } catch (_) {}
    }
  }

  Future<void> _onToggleDutyStatus(
    ToggleDutyStatusEvent event,
    Emitter<DeliveryTasksState> emit,
  ) async {
    if (state is DeliveryTasksLoaded) {
      final currentState = state as DeliveryTasksLoaded;
      emit(currentState.copyWith(isOnline: event.isOnline));

      final storage = await StorageService.getInstance();
      await storage.setBool(AppKeys.isOnline, event.isOnline);
    }
  }
}
