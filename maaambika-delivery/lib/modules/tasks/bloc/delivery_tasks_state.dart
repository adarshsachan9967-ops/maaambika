import '../../../data/models/delivery_task.dart';

abstract class DeliveryTasksState {
  const DeliveryTasksState();
}

class DeliveryTasksInitial extends DeliveryTasksState {
  const DeliveryTasksInitial();
}

class DeliveryTasksLoading extends DeliveryTasksState {
  const DeliveryTasksLoading();
}

class DeliveryTasksLoaded extends DeliveryTasksState {
  final List<DeliveryTask> tasks;
  final bool isOnline;
  final String? message;

  const DeliveryTasksLoaded({
    required this.tasks,
    required this.isOnline,
    this.message,
  });

  int get activeTasksCount => tasks.where((t) => !t.isDelivered).length;
  int get completedTasksCount => tasks.where((t) => t.isDelivered).length;

  DeliveryTasksLoaded copyWith({
    List<DeliveryTask>? tasks,
    bool? isOnline,
    String? message,
  }) {
    return DeliveryTasksLoaded(
      tasks: tasks ?? this.tasks,
      isOnline: isOnline ?? this.isOnline,
      message: message,
    );
  }
}

class DeliveryTasksError extends DeliveryTasksState {
  final String errorMessage;

  const DeliveryTasksError(this.errorMessage);
}
