class UpdateTaskStatusRequest {
  final String taskId;
  final String status;

  const UpdateTaskStatusRequest({
    required this.taskId,
    required this.status,
  });

  Map<String, dynamic> toData() {
    return {
      'taskId': taskId,
      'status': status,
    };
  }
}
