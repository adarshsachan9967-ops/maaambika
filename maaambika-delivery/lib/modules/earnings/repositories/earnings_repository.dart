import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/instant_payout_request.dart';

abstract class EarningsRepository {
  Future<Response> getEarnings();
  Future<Response> requestInstantPayout(InstantPayoutRequest request);
}

class EarningsRepositoryImpl implements EarningsRepository {
  final Dio _dio;

  EarningsRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getEarnings() {
    return _dio.get(ApiConstants.earnings);
  }

  @override
  Future<Response> requestInstantPayout(InstantPayoutRequest request) {
    return _dio.post(
      ApiConstants.instantPayout,
      data: request.toData(),
    );
  }
}
