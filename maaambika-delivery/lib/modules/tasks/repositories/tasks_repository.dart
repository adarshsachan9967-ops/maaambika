import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/update_task_status_request.dart';
import '../models/requests/verify_otp_request.dart';

abstract class TasksRepository {
  Future<Response> getTasks();
  Future<Response> updateTaskStatus(UpdateTaskStatusRequest request);
  Future<Response> verifyOtp(VerifyOtpRequest request);
}

class TasksRepositoryImpl implements TasksRepository {
  final Dio _dio;

  TasksRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getTasks() {
    return _dio.get(ApiConstants.tasks);
  }

  @override
  Future<Response> updateTaskStatus(UpdateTaskStatusRequest request) {
    return _dio.post(
      ApiConstants.taskStatusUpdate,
      data: request.toData(),
    );
  }

  @override
  Future<Response> verifyOtp(VerifyOtpRequest request) {
    return _dio.post(
      ApiConstants.verifyOtp,
      data: request.toData(),
    );
  }
}
