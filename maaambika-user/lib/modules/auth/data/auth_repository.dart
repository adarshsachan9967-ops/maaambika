import '../../../core/services/api_service.dart';
import '../../../core/services/session_service.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    return ApiService.login(identifier: phone, password: password);
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    return ApiService.signUp(name: name, phone: phone, email: email, password: password);
  }

  Future<void> logout() async {
    await SessionService.clearSession();
  }
}
