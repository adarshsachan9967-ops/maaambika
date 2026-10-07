class DutyStatusRequest {
  final bool isOnline;

  const DutyStatusRequest({
    required this.isOnline,
  });

  Map<String, dynamic> toData() {
    return {
      'isOnline': isOnline,
    };
  }
}
