import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/fetch_partner_orders_request.dart';

abstract class PartnerOrdersRepository {
  Future<Response> getOrders(FetchPartnerOrdersRequest request);
}

class PartnerOrdersRepositoryImpl implements PartnerOrdersRepository {
  final Dio _dio;

  PartnerOrdersRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getOrders(FetchPartnerOrdersRequest request) {
    return _dio.get(
      ApiConstants.partnerOrders,
      queryParameters: request.toQueryParameters(),
    );
  }
}
