import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/fetch_overview_request.dart';

abstract class OverviewRepository {
  Future<Response> getOverview(FetchOverviewRequest request);
}

class OverviewRepositoryImpl implements OverviewRepository {
  final Dio _dio;

  OverviewRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getOverview(FetchOverviewRequest request) {
    return _dio.get(
      ApiConstants.dashboardOverview,
      queryParameters: request.toQueryParameters(),
    );
  }
}
