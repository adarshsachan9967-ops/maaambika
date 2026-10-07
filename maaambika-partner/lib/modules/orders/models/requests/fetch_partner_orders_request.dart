class FetchPartnerOrdersRequest {
  final String? status;
  final int page;
  final int limit;

  const FetchPartnerOrdersRequest({
    this.status,
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      if (status != null && status!.isNotEmpty) 'status': status,
      'page': page,
      'limit': limit,
    };
  }
}
