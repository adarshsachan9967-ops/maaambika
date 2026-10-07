import '../../../../data/models/store_kyc.dart';

abstract class PartnerProfileState {
  const PartnerProfileState();
}

class PartnerProfileInitialState extends PartnerProfileState {
  const PartnerProfileInitialState();
}

class PartnerProfileLoadingState extends PartnerProfileState {
  const PartnerProfileLoadingState();
}

class PartnerProfileLoadedState extends PartnerProfileState {
  final StoreKYC store;
  final bool isFromFallback;
  final String? message;

  const PartnerProfileLoadedState({
    required this.store,
    this.isFromFallback = false,
    this.message,
  });
}

class PartnerProfileLoggedOutState extends PartnerProfileState {
  const PartnerProfileLoggedOutState();
}

class PartnerProfileErrorState extends PartnerProfileState {
  final String errorMessage;
  final StoreKYC fallbackStore;

  const PartnerProfileErrorState({
    required this.errorMessage,
    required this.fallbackStore,
  });
}
