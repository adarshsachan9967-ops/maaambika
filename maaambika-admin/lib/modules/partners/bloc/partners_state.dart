import '../../../../data/models/partner_store.dart';

abstract class PartnersState {
  const PartnersState();
}

class PartnersInitialState extends PartnersState {
  const PartnersInitialState();
}

class PartnersLoadingState extends PartnersState {
  const PartnersLoadingState();
}

class PartnersLoadedState extends PartnersState {
  final List<PartnerStore> partners;
  final bool isFromFallback;
  final String? message;

  const PartnersLoadedState({
    required this.partners,
    this.isFromFallback = false,
    this.message,
  });

  PartnersLoadedState copyWith({
    List<PartnerStore>? partners,
    bool? isFromFallback,
    String? message,
  }) {
    return PartnersLoadedState(
      partners: partners ?? this.partners,
      isFromFallback: isFromFallback ?? this.isFromFallback,
      message: message,
    );
  }
}

class PartnersErrorState extends PartnersState {
  final String errorMessage;
  final List<PartnerStore> fallbackPartners;

  const PartnersErrorState({
    required this.errorMessage,
    this.fallbackPartners = const [],
  });
}
