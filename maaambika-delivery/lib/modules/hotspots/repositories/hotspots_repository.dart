import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';

abstract class HotspotsRepository {
  Future<Response> getHotspots();
  Future<Response> getHubs();
}

class HotspotsRepositoryImpl implements HotspotsRepository {
  final Dio _dio;

  HotspotsRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getHotspots() {
    return _dio.get(ApiConstants.hotspots);
  }

  @override
  Future<Response> getHubs() {
    return _dio.get(ApiConstants.hubs);
  }
}
