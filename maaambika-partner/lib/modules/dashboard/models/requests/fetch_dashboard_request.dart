class FetchDashboardRequest {
  final String date;

  const FetchDashboardRequest({this.date = 'today'});

  Map<String, dynamic> toQueryParameters() {
    return {
      'date': date,
    };
  }
}
