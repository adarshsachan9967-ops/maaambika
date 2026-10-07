import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/submit_inspection_request.dart';

abstract class InspectionRepository {
  Future<Response> submitInspection(SubmitInspectionRequest request);
}

class InspectionRepositoryImpl implements InspectionRepository {
  final Dio _dio;

  InspectionRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> submitInspection(SubmitInspectionRequest request) {
    return _dio.post(
      ApiConstants.partnerInspect,
      data: request.toData(),
    );
  }
}
