import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/instant_payout_request.dart';

abstract class PayoutsRepository {
  Future<Response> executePayout(InstantPayoutRequest request);
}

class PayoutsRepositoryImpl implements PayoutsRepository {
  final Dio _dio;

  PayoutsRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> executePayout(InstantPayoutRequest request) {
    return _dio.post(
      ApiConstants.partnerPayout,
      data: request.toData(),
    );
  }
}
