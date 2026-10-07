class FetchCouponsRequest {
  final String? status;

  const FetchCouponsRequest({this.status});

  Map<String, dynamic> toQueryParameters() {
    return {
      if (status != null && status!.isNotEmpty) 'status': status,
    };
  }
}
