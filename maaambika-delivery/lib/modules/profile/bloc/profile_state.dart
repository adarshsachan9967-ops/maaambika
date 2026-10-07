import '../models/responses/profile_response.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileResponse profile;

  const ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String errorMessage;
  const ProfileError(this.errorMessage);
}
