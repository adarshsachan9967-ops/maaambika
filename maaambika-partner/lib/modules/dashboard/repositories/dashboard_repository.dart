import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/fetch_dashboard_request.dart';

abstract class DashboardRepository {
  Future<Response> getDashboard(FetchDashboardRequest request);
}

class DashboardRepositoryImpl implements DashboardRepository {
  final Dio _dio;

  DashboardRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getDashboard(FetchDashboardRequest request) {
    return _dio.get(
      ApiConstants.dashboard,
      queryParameters: request.toQueryParameters(),
    );
  }
}
