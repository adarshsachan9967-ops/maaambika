import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/fetch_partners_request.dart';
import '../models/requests/approve_kyc_request.dart';

abstract class PartnersRepository {
  Future<Response> getPartners(FetchPartnersRequest request);
  Future<Response> approveKyc(ApproveKycRequest request);
}

class PartnersRepositoryImpl implements PartnersRepository {
  final Dio _dio;

  PartnersRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getPartners(FetchPartnersRequest request) {
    return _dio.get(
      ApiConstants.adminPartners,
      queryParameters: request.toQueryParameters(),
    );
  }

  @override
  Future<Response> approveKyc(ApproveKycRequest request) {
    return _dio.post(
      '${ApiConstants.adminPartners}/approve-kyc',
      data: request.toData(),
    );
  }
}
