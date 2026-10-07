class ApproveKycRequest {
  final String partnerName;
  final String status;

  const ApproveKycRequest({
    required this.partnerName,
    this.status = 'Approved',
  });

  Map<String, dynamic> toData() {
    return {
      'partnerName': partnerName,
      'status': status,
    };
  }
}
