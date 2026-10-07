class FetchOverviewRequest {
  final String date;

  const FetchOverviewRequest({this.date = 'today'});

  Map<String, dynamic> toQueryParameters() {
    return {
      'date': date,
    };
  }
}
