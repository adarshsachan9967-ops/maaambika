abstract class DeliveryTasksEvent {
  const DeliveryTasksEvent();
}

class LoadDeliveryTasksEvent extends DeliveryTasksEvent {
  const LoadDeliveryTasksEvent();
}

class UpdateTaskStatusEvent extends DeliveryTasksEvent {
  final String taskId;
  final String newStatus;

  const UpdateTaskStatusEvent({
    required this.taskId,
    required this.newStatus,
  });
}

class CompleteDeliveryTaskEvent extends DeliveryTasksEvent {
  final String taskId;

  const CompleteDeliveryTaskEvent({
    required this.taskId,
  });
}

class ToggleDutyStatusEvent extends DeliveryTasksEvent {
  final bool isOnline;

  const ToggleDutyStatusEvent(this.isOnline);
}
