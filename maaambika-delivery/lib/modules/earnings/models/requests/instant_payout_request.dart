class InstantPayoutRequest {
  final double amount;

  const InstantPayoutRequest({
    required this.amount,
  });

  Map<String, dynamic> toData() {
    return {
      'amount': amount,
    };
  }
}
