abstract class AdminOrdersEvent {
  const AdminOrdersEvent();
}

class LoadAdminOrdersEvent extends AdminOrdersEvent {
  final bool isRefresh;
  const LoadAdminOrdersEvent({this.isRefresh = false});
}

class AssignRiderEvent extends AdminOrdersEvent {
  final String orderId;
  final String riderId;
  final String riderName;

  const AssignRiderEvent({
    required this.orderId,
    required this.riderId,
    required this.riderName,
  });
}
