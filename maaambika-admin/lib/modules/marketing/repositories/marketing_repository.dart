import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/fetch_coupons_request.dart';
import '../models/requests/send_broadcast_request.dart';

abstract class MarketingRepository {
  Future<Response> getCoupons(FetchCouponsRequest request);
  Future<Response> sendBroadcast(SendBroadcastRequest request);
}

class MarketingRepositoryImpl implements MarketingRepository {
  final Dio _dio;

  MarketingRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getCoupons(FetchCouponsRequest request) {
    return _dio.get(
      ApiConstants.adminCoupons,
      queryParameters: request.toQueryParameters(),
    );
  }

  @override
  Future<Response> sendBroadcast(SendBroadcastRequest request) {
    return _dio.post(
      ApiConstants.adminBroadcast,
      data: request.toData(),
    );
  }
}
