import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/duty_status_request.dart';

abstract class ProfileRepository {
  Future<Response> getProfile();
  Future<Response> updateDutyStatus(DutyStatusRequest request);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final Dio _dio;

  ProfileRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getProfile() {
    return _dio.get(ApiConstants.profile);
  }

  @override
  Future<Response> updateDutyStatus(DutyStatusRequest request) {
    return _dio.post(
      ApiConstants.dutyStatus,
      data: request.toData(),
    );
  }
}
