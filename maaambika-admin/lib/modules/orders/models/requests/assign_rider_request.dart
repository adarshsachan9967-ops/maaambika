class AssignRiderRequest {
  final String orderId;
  final String riderId;
  final String riderName;

  const AssignRiderRequest({
    required this.orderId,
    required this.riderId,
    required this.riderName,
  });

  Map<String, dynamic> toData() {
    return {
      'orderId': orderId,
      'riderId': riderId,
      'riderName': riderName,
    };
  }
}
