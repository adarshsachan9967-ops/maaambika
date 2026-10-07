import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/update_profile_request.dart';

abstract class PartnerProfileRepository {
  Future<Response> getProfile();
  Future<Response> updateProfile(UpdateProfileRequest request);
}

class PartnerProfileRepositoryImpl implements PartnerProfileRepository {
  final Dio _dio;

  PartnerProfileRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getProfile() {
    return _dio.get(ApiConstants.partnerProfile);
  }

  @override
  Future<Response> updateProfile(UpdateProfileRequest request) {
    return _dio.put(
      ApiConstants.partnerProfile,
      data: request.toData(),
    );
  }
}
