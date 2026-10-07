class FetchPartnersRequest {
  final String? kycStatus;

  const FetchPartnersRequest({this.kycStatus});

  Map<String, dynamic> toQueryParameters() {
    return {
      if (kycStatus != null && kycStatus!.isNotEmpty) 'kyc': kycStatus,
    };
  }
}
