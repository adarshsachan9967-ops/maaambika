import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/session_service.dart';
import '../../../models/user_profile.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit({AuthRepository? repository})
      : _repository = repository ?? AuthRepository(),
        super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    final isLoggedIn = SessionService.isLoggedIn();
    if (isLoggedIn) {
      final saved = SessionService.getSavedProfile();
      if (saved != null) {
        emit(Authenticated(UserProfile.fromJson(saved)));
        return;
      }
    }
    emit(const Unauthenticated());
  }

  Future<bool> login(String phone, String password) async {
    emit(const AuthLoading());
    try {
      final res = await _repository.login(phone: phone, password: password);
      if (res['success'] == true) {
        final userData = res['user'] as Map<String, dynamic>? ?? {};
        final profile = UserProfile(
          name: userData['name'] ?? 'Maa Ambika Customer',
          phone: userData['phone'] ?? phone,
          email: userData['email'] ?? '',
          avatarIndex: userData['avatarIndex'] ?? 0,
          upiId: userData['upiId'] ?? '',
          bankAccount: userData['bankAccount'] ?? '',
          address: userData['address'] ?? '',
        );
        await SessionService.saveUserSession(
          name: profile.name,
          phone: profile.phone,
          email: profile.email,
          upiId: profile.upiId,
          bankAccount: profile.bankAccount,
          address: profile.address,
          avatarIndex: profile.avatarIndex,
        );
        emit(Authenticated(profile));
        return true;
      } else {
        emit(AuthError(res['message'] ?? 'Login failed'));
        return false;
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      return false;
    }
  }

  Future<bool> register(String name, String phone, String email, String password) async {
    emit(const AuthLoading());
    try {
      final res = await _repository.register(name: name, phone: phone, email: email, password: password);
      if (res['success'] == true) {
        final profile = UserProfile(
          name: name.trim(),
          phone: phone.trim(),
          email: email.trim(),
          avatarIndex: 0,
          upiId: '',
          bankAccount: '',
          address: '',
        );
        await SessionService.saveUserSession(
          name: profile.name,
          phone: profile.phone,
          email: profile.email,
        );
        emit(Authenticated(profile));
        return true;
      } else {
        emit(AuthError(res['message'] ?? 'Registration failed'));
        return false;
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const Unauthenticated());
  }
}
