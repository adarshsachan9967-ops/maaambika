import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/responses/profile_response.dart';
import '../repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({ProfileRepository? repository})
      : repository = repository ?? ProfileRepositoryImpl(),
        super(const ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      ProfileResponse profile = ProfileResponse.fromJson(null);
      try {
        final res = await repository.getProfile();
        if (res.statusCode == 200 && res.data != null) {
          profile = ProfileResponse.fromJson(res.data);
        }
      } catch (e) {
        if (kDebugMode) debugPrint('ProfileBloc: error fetching profile ($e)');
      }
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }
}
