class InstantPayoutRequest {
  final String upiId;
  final int amount;

  const InstantPayoutRequest({
    required this.upiId,
    required this.amount,
  });

  Map<String, dynamic> toData() {
    return {
      'recipientUpi': upiId,
      'amount': amount,
    };
  }
}
