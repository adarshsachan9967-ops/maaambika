import '../../../../data/models/delivery_task.dart';

class TasksResponse {
  final bool success;
  final List<DeliveryTask> tasks;
  final String? message;

  TasksResponse({
    required this.success,
    required this.tasks,
    this.message,
  });

  factory TasksResponse.fromJson(dynamic json) {
    if (json is List) {
      return TasksResponse(
        success: true,
        tasks: json
            .map((item) => DeliveryTask.fromMap(item as Map<String, dynamic>))
            .toList(),
      );
    }
    if (json is Map<String, dynamic>) {
      final list = (json['data'] ?? json['tasks']) as List<dynamic>?;
      return TasksResponse(
        success: json['success'] as bool? ?? true,
        tasks: list
                ?.map((item) => DeliveryTask.fromMap(item as Map<String, dynamic>))
                .toList() ??
            [],
        message: json['message'] as String?,
      );
    }
    return TasksResponse(success: false, tasks: [], message: 'Invalid data format');
  }
}
