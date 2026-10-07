import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/fetch_admin_orders_request.dart';
import '../models/requests/assign_rider_request.dart';

abstract class AdminOrdersRepository {
  Future<Response> getOrders(FetchAdminOrdersRequest request);
  Future<Response> assignRider(AssignRiderRequest request);
}

class AdminOrdersRepositoryImpl implements AdminOrdersRepository {
  final Dio _dio;

  AdminOrdersRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getOrders(FetchAdminOrdersRequest request) {
    return _dio.get(
      ApiConstants.adminOrders,
      queryParameters: request.toQueryParameters(),
    );
  }

  @override
  Future<Response> assignRider(AssignRiderRequest request) {
    return _dio.post(
      '${ApiConstants.adminOrders}/${request.orderId}/assign-rider',
      data: request.toData(),
    );
  }
}
